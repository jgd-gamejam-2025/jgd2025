# MazeManager.gd
extends Node3D

# --- (你的 physics_wall 和 visual_wall 变量保持不变) ---
@export var physics_wall_scene: PackedScene
@export var visual_wall_scene: PackedScene

# --- **关键改动** ---
@onready var main_maze_area_collider: CollisionShape3D = $MainMazeArea/CollisionShape3D
# --- 结束改动 ---

@export var player_path: NodePath
# ... (你其他的 @export 变量保持不变) ...
@export var wall_rise_time = 2.5
@export var ripple_delay = 0.05
@export_range(1, 100, 1) var ripple_batch_size: int = 1

@onready var grid_map = $GridMap
@onready var rise_timer = $RiseTimer
@onready var player = get_node(player_path)

var maze_has_risen = false
var opening_ended = false
var main_maze_aabb: AABB

var wall_height: float = 1.0 # 一个内部变量，将在 _ready() 中被自动设置
@export var wwise_wall_rise :WwiseEvent


func _ready():
	# --- **新代码：自动检测墙体高度** ---
	if physics_wall_scene:
		# 1. 临时实例化一个墙体
		var temp_wall = physics_wall_scene.instantiate()
		
		# 2. 查找它的碰撞体或模型来获取高度
		# (我们假设它有一个 BoxShape3D 或 BoxMesh)
		var collision_shape: CollisionShape3D = temp_wall.find_child("CollisionShape3D", true, false)
		if collision_shape and collision_shape.shape and collision_shape.shape is BoxShape3D:
			wall_height = collision_shape.shape.size.y
		else:
			# 如果找不到碰撞体，就找模型
			var mesh_instance: MeshInstance3D = temp_wall.find_child("MeshInstance3D", true, false)
			if mesh_instance and mesh_instance.mesh and mesh_instance.mesh is BoxMesh:
				wall_height = mesh_instance.mesh.size.y
			else:
				print_rich("[color=yellow]警告：[/color] 无法在 'physics_wall_scene' 中自动检测 'wall_height'。将使用默认值 1.0。")
		
		# 3. 销毁临时实例
		temp_wall.queue_free()
	else:
		print_rich("[color=red]错误：[/color] 'physics_wall_scene' 未指定！无法确定 'wall_height'。")
	
	grid_map.hide()
	grid_map.collision_layer = 0
	if not main_maze_area_collider:
		print_rich("[color=red]错误：[/color]MazeManager 找不到 'MainMazeArea/CollisionShape3D' 节点！")

	
func _process(_delta):
	if not maze_has_risen and player.is_on_floor() and opening_ended:
		maze_has_risen = true
		print("玩家已落地，启动计时器！")
		rise_timer.start()


func _on_rise_timer_timeout():
	print("计时结束，迷宫升起！")
	# 播放墙体升起音效
	if wwise_wall_rise:
		wwise_wall_rise.post(self)
	raise_maze()


# --- 这是被重写的 raise_maze 函数 ---
func raise_maze():
	if not main_maze_area_collider: return # 安全检查

	# --- **新逻辑** ---
	# 1. 动态地从你拖动的Box中创建 AABB
	# (注意：这假设 Area3D 和 GridMap 都是 MazeManager 的子节点)
	var box_shape: BoxShape3D = main_maze_area_collider.shape
	var box_size = box_shape.size
	# 盒子的中心点(本地坐标) = Area3D的本地位置 + CollisionShape3D的本地位置
	var box_center_local = main_maze_area_collider.get_parent_node_3d().position + main_maze_area_collider.position
	
	# AABB 的起始点 = 中心点 - 尺寸的一半
	var aabb_pos_local = box_center_local - (box_size / 2.0)
	main_maze_aabb = AABB(aabb_pos_local, box_size) # 存储这个AABB
	# --- 结束新逻辑 ---
	
	# 2. 获取玩家的2D位置（这是扩散中心）
	var player_pos_2d = player.global_position * Vector3(1, 0, 1)
	
	# 3. 遍历 GridMap，找出所有墙
	var cells_to_raise: Array = []
	var cells_data: Dictionary = {}
	
	for cell in grid_map.get_used_cells():
		var item_id = grid_map.get_cell_item(cell)
		
		var local_pos = grid_map.map_to_local(cell)
		var dist_2d = (local_pos * Vector3(1, 0, 1)).distance_to(player_pos_2d)
		var is_physics = false 
			
		# --- **核心分层逻辑** (使用动态AABB) ---
		if main_maze_aabb.has_point(local_pos):
			is_physics = true
			# --- 结束核心逻辑 ---
			
		cells_to_raise.append(cell)
		cells_data[cell] = {"distance": dist_2d, "is_physics": is_physics}

	cells_to_raise.sort_custom(func(a, b): return cells_data[a].distance < cells_data[b].distance)

	var player_on_wall_cell = _get_player_on_wall_cell()
	var player_wall_index = -1
	
	var tween = create_tween()
	tween.set_parallel(true)
	var batch_size = max(1, ripple_batch_size)
	
	for i in range(cells_to_raise.size()):
		var cell: Vector3i = cells_to_raise[i]
		var data = cells_data[cell]
		var wall_instance: Node3D = null
		
		if data.is_physics:
			wall_instance = physics_wall_scene.instantiate()
		else:
			wall_instance = visual_wall_scene.instantiate()

		var local_pos = grid_map.map_to_local(cell)
		wall_instance.position = local_pos
		wall_instance.position.y = - (wall_height / 2.0)
		wall_instance.hide()
		add_child(wall_instance)
		
		if data.is_physics:
			wall_instance.add_to_group("walls")
		
		var calculated_delay = (i / batch_size) * ripple_delay
		tween.tween_callback(wall_instance.show).set_delay(calculated_delay)
		var target_y = wall_instance.position.y + wall_height
		tween.tween_property(wall_instance, "position:y", target_y, wall_rise_time).set_delay(calculated_delay).set_ease(Tween.EASE_OUT_IN)

		if cell == player_on_wall_cell:
			player_wall_index = i

	if player_wall_index != -1:
		print("玩家在墙顶上，将随墙体一起上升。")
		var player_delay = (player_wall_index / batch_size) * ripple_delay
		var player_target_y = player.global_position.y + wall_height
		tween.tween_property(player, "global_position:y", player_target_y, wall_rise_time).set_delay(player_delay).set_ease(Tween.EASE_OUT_IN)

func _get_player_on_wall_cell() -> Vector3i:
	if not main_maze_aabb: return Vector3i.MAX # 确保AABB已经被创建
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + Vector3.DOWN * 1.0)
	query.exclude = [player]
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_pos_local = grid_map.to_local(result.position)
		var cell = grid_map.local_to_map(hit_pos_local)
		
		if main_maze_aabb.has_point(hit_pos_local):
			return cell
			
	return Vector3i.MAX

func _is_player_on_wall_top() -> Node:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + Vector3.DOWN * 1.0)
	query.exclude = [player]
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider.is_in_group("walls"):
			return result.collider 
	return null
	
func _on_maze_load_wall_end_opening_sig() -> void:
	opening_ended = true
