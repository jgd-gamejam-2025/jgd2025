# RotatingDoor.gd
extends Node3D

# --- 可调整参数 ---
@export_group("动画设置")
@export var close_duration: float = 1.0
@export var delay_per_row: float = 0.1
@export var target_rotation_degrees: float = 90.0
@export var rotation_axis: Vector3 = Vector3.UP
@export var center_x_position: float = 0.0
@export var will_open: bool = false  # 如果为true，门初始关闭，触发时打开

# --- 内部变量 ---
# 【修改】使用 $ 符号自动查找子节点
# (请确保你的子节点名字就是 "TeethContainer" 和 "ClosedCollision")
@onready var teeth_container: Node3D = $TeethContainer
@onready var closed_collision: StaticBody3D = $ClosedCollision
var trigger_area: Area3D = null # 将在 _ready 中查找

var teeth_left: Array[Node3D] = []
var teeth_right: Array[Node3D] = []
var is_closed: bool = false
var initial_rotations: Dictionary = {}  # 存储每个门牙的初始旋转


func _ready():
	# 1. 验证内部节点
	if not is_instance_valid(teeth_container):
		push_error("RotatingDoor 未找到子节点 'TeethContainer'!")
		return
	if not is_instance_valid(closed_collision):
		push_error("RotatingDoor 未找到子节点 'ClosedCollision'!")
		return

	# 2. 【新】查找外部添加的 TriggerArea
	for child in get_children():
		if child is Area3D:
			trigger_area = child
			break # 找到第一个 Area3D 就停止

	if not is_instance_valid(trigger_area):
		push_error("RotatingDoor 未在其子节点中找到 Area3D 触发器!")
		# 或者你可以让门继续工作，只是永远不会关上
		# set_process(false)
		# set_physics_process(false)
		# return
	else:
		# 3. 连接触发区域信号 (如果找到了)
		# 使用 call_deferred 确保连接时 Area3D 已准备好
		trigger_area.body_entered.connect(_on_trigger_area_body_entered, CONNECT_DEFERRED)
		print("RotatingDoor 已连接到触发器: ", trigger_area.name)


	# 4. 获取并区分左右门牙 (同之前)
	# --- **修改** 添加类型提示 ---
	var temp_left: Array[Node3D] = []
	var temp_right: Array[Node3D] = []
	# --- **结束修改** ---
	# (修改：只在 teeth_container 里查找牙齿)
	for child in teeth_container.get_children():
		if child is Node3D: # 假设 DoorTooth 的根是 Node3D
			# 保存初始旋转
			initial_rotations[child] = child.rotation
			if child.position.x < center_x_position:
				temp_left.append(child)
			else:
				temp_right.append(child)

	# 5. 分别按 Y 坐标排序 (同之前)
	temp_left.sort_custom(func(a, b): return a.position.y < b.position.y)
	temp_right.sort_custom(func(a, b): return a.position.y < b.position.y)
	teeth_left = temp_left
	teeth_right = temp_right

	# 6. 根据 will_open 设置初始状态
	if will_open:
		# 门初始关闭，立即旋转到关闭位置
		_set_door_closed_instantly()
		is_closed = true
		closed_collision.set_collision_layer_value(1, true)
		closed_collision.set_collision_mask_value(1, true)
	else:
		# 门初始打开，禁用碰撞
		is_closed = false
		closed_collision.set_collision_layer_value(1, false)
		closed_collision.set_collision_mask_value(1, false)


func _set_door_closed_instantly():
	"""立即将门设置到关闭状态（无动画）"""
	var target_rotation_rad_left = deg_to_rad(target_rotation_degrees)
	var target_rotation_rad_right = deg_to_rad(-target_rotation_degrees)
	
	for tooth in teeth_left:
		if tooth in initial_rotations:
			tooth.rotation = initial_rotations[tooth] + rotation_axis.normalized() * target_rotation_rad_left
	
	for tooth in teeth_right:
		if tooth in initial_rotations:
			tooth.rotation = initial_rotations[tooth] + rotation_axis.normalized() * target_rotation_rad_right


func _on_trigger_area_body_entered(body):
	if body.is_in_group("player"):
		if will_open:
			# will_open 模式：门关着，触发打开
			if is_closed:
				open_door()
		else:
			# 正常模式：门开着，触发关闭
			if not is_closed:
				close_door()


func close_door():
	is_closed = true
	# (可选) 禁用触发器
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = false

	var tween = create_tween()
	tween.set_parallel(true)

	var max_delay = 0.0

	# --- (处理左右旋转的代码保持不变) ---
	# 处理左侧
	var target_rotation_rad_left = deg_to_rad(target_rotation_degrees)
	for i in range(teeth_left.size()):
		var tooth = teeth_left[i]
		var delay = i * delay_per_row
		var final_rotation = tooth.rotation + rotation_axis.normalized() * target_rotation_rad_left
		tween.tween_property(tooth, "rotation", final_rotation, close_duration)\
			 .set_delay(delay)\
			 .set_ease(Tween.EASE_OUT_IN)
		if delay > max_delay: max_delay = delay

	# 处理右侧
	var target_rotation_rad_right = deg_to_rad(-target_rotation_degrees)
	for i in range(teeth_right.size()):
		var tooth = teeth_right[i]
		var delay = i * delay_per_row
		var final_rotation = tooth.rotation + rotation_axis.normalized() * target_rotation_rad_right
		tween.tween_property(tooth, "rotation", final_rotation, close_duration)\
			 .set_delay(delay)\
			 .set_ease(Tween.EASE_OUT_IN)
		if delay > max_delay: max_delay = delay
	# --- 结束处理 ---

	# 等所有动画完成后启用碰撞体 (同之前)
	var total_animation_time = max_delay + close_duration
	get_tree().create_timer(total_animation_time).timeout.connect(func():
		if is_instance_valid(closed_collision): # 安全检查
			closed_collision.set_collision_layer_value(1, true)
			closed_collision.set_collision_mask_value(1, true)
			print("旋转门已关闭")
	)


func open_door():
	"""打开门，将所有门牙旋转回初始位置"""
	if not is_closed:
		return  # 门已经是开着的
	
	is_closed = false
	
	# 禁用关闭碰撞体
	if is_instance_valid(closed_collision):
		closed_collision.set_collision_layer_value(1, false)
		closed_collision.set_collision_mask_value(1, false)
	
	# 重新启用触发器（可选）
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# 将左侧门牙旋转回初始位置
	for i in range(teeth_left.size()):
		var tooth = teeth_left[i]
		var delay = i * delay_per_row
		if tooth in initial_rotations:
			tween.tween_property(tooth, "rotation", initial_rotations[tooth], close_duration)\
				 .set_delay(delay)\
				 .set_ease(Tween.EASE_IN_OUT)
	
	# 将右侧门牙旋转回初始位置
	for i in range(teeth_right.size()):
		var tooth = teeth_right[i]
		var delay = i * delay_per_row
		if tooth in initial_rotations:
			tween.tween_property(tooth, "rotation", initial_rotations[tooth], close_duration)\
				 .set_delay(delay)\
				 .set_ease(Tween.EASE_IN_OUT)
	
	print("旋转门已打开")
