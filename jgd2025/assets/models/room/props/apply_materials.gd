@tool
extends EditorScript

# 材质映射规则：根据FBX名称自动匹配合适的材质
const MATERIAL_MAPPING = {
	# 地板类
	"floor": "res://assets/models/room/tileable/floor/wood_floor_material.tres",
	
	# 墙面类（墙、天花板）
	"wall": "res://assets/models/room/tileable/plaster_wall/plaster_wall_material.tres",
	"ceiling": "res://assets/models/room/tileable/plaster_wall/plaster_wall_material.tres",
	
	# 木制品类（床、桌子、抽屉、门、相框等）
	"bed": "res://assets/models/room/tileable/wood/wood_material.tres",
	"desk": "res://assets/models/room/tileable/wood/wood_material.tres",
	"drawer": "res://assets/models/room/tileable/wood/wood_material.tres",
	"door": "res://assets/models/room/tileable/wood/wood_material.tres",
	"chair": "res://assets/models/room/tileable/wood/wood_material.tres",
	"photo": "res://assets/models/room/tileable/wood/wood_material.tres",
	"round_photo": "res://assets/models/room/tileable/wood/wood_material.tres",
}

func _run():
	var props_path = "res://assets/models/room/props/"
	var dir = DirAccess.open(props_path)
	
	if not dir:
		print("无法打开目录: ", props_path)
		return
	
	print("====== 开始处理FBX材质导入设置 ======")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var processed_count = 0
	var applied_count = 0
	
	while file_name != "":
		if file_name.ends_with(".fbx"):
			var fbx_path = props_path + file_name
			var import_path = fbx_path + ".import"
			
			print("\n处理: ", file_name)
			
			var material_path = get_material_for_fbx(file_name)
			
			if material_path:
				if modify_import_settings(import_path, fbx_path, material_path):
					applied_count += 1
					print("  ✓ 已设置external材质: ", material_path.get_file())
				else:
					print("  ✗ 修改导入设置失败")
			else:
				print("  ○ 未找到匹配的材质，跳过")
			
			processed_count += 1
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	print("\n====== 处理完成 ======")
	print("总共处理: ", processed_count, " 个FBX文件")
	print("成功设置: ", applied_count, " 个材质")
	print("\n请重新打开项目或手动reimport以应用更改")
	
	# 触发重新导入
	EditorInterface.get_resource_filesystem().scan()

# 根据FBX文件名获取对应的材质路径
func get_material_for_fbx(fbx_name: String) -> String:
	var name_lower = fbx_name.to_lower()
	
	for key in MATERIAL_MAPPING.keys():
		if key in name_lower:
			return MATERIAL_MAPPING[key]
	
	return ""

# 修改FBX的导入设置文件
func modify_import_settings(import_path: String, fbx_path: String, material_path: String) -> bool:
	# 首先加载FBX场景来获取材质名称
	var scene = load(fbx_path)
	if not scene:
		print("    错误: 无法加载 ", fbx_path)
		return false
	
	var instance = scene.instantiate()
	if not instance:
		print("    错误: 无法实例化场景")
		return false
	
	# 收集所有材质名称
	var material_names = []
	collect_material_names(instance, material_names)
	instance.queue_free()
	
	if material_names.is_empty():
		print("    警告: 未找到任何材质")
		return false
	
	# 读取现有的import文件
	var file = FileAccess.open(import_path, FileAccess.READ)
	if not file:
		print("    错误: 无法读取 ", import_path)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	# 修改材质设置
	# materials/extract=1 表示提取为external
	content = content.replace("materials/extract=0", "materials/extract=1")
	content = content.replace('materials/extract_path=""', 'materials/extract_path="' + props_path + '"')
	
	# 构建_subresources字典，为每个材质指定external路径
	var subresources_dict = {}
	for mat_name in material_names:
		var mat_key = "materials/" + mat_name
		subresources_dict[mat_key] = {
			"use_external/enabled": true,
			"use_external/path": material_path
		}
	
	# 替换_subresources部分
	var subresources_str = dict_to_import_string(subresources_dict)
	
	# 查找并替换_subresources行
	var lines = content.split("\n")
	var new_lines = []
	var found_subresources = false
	
	for line in lines:
		if line.begins_with("_subresources="):
			new_lines.append("_subresources=" + subresources_str)
			found_subresources = true
		else:
			new_lines.append(line)
	
	content = "\n".join(new_lines)
	
	# 写回文件
	file = FileAccess.open(import_path, FileAccess.WRITE)
	if not file:
		print("    错误: 无法写入 ", import_path)
		return false
	
	file.store_string(content)
	file.close()
	
	print("    → 已设置 ", material_names.size(), " 个材质为external")
	for mat_name in material_names:
		print("      - ", mat_name)
	
	return true

# 递归收集所有材质名称
func collect_material_names(node: Node, names: Array):
	if node is MeshInstance3D:
		var mesh = node.mesh
		if mesh:
			for i in range(mesh.get_surface_count()):
				var mat = mesh.surface_get_material(i)
				if mat and mat.resource_name:
					if not mat.resource_name in names:
						names.append(mat.resource_name)
	
	for child in node.get_children():
		collect_material_names(child, names)

# 将字典转换为Godot import文件格式的字符串
func dict_to_import_string(dict: Dictionary) -> String:
	if dict.is_empty():
		return "{}"
	
	var result = "{\n"
	for key in dict.keys():
		var value = dict[key]
		result += '"' + key + '": {\n'
		
		if value is Dictionary:
			for sub_key in value.keys():
				var sub_value = value[sub_key]
				if sub_value is bool:
					result += '"' + sub_key + '": ' + str(sub_value) + ',\n'
				elif sub_value is String:
					result += '"' + sub_key + '": "' + sub_value + '",\n'
				else:
					result += '"' + sub_key + '": ' + str(sub_value) + ',\n'
		
		result = result.trim_suffix(",\n") + "\n},\n"
	
	result = result.trim_suffix(",\n") + "\n}"
	return result
