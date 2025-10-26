# SlidingDoor.gd
extends Node3D

@export_group("动画设置")
# 门牙完全伸出到位所需的“大概”时间
@export var close_duration: float = 2.0
# 每个门牙伸出速度的随机范围 (比例/秒)
@export var random_speed_min: float = 0.5
@export var random_speed_max: float = 1.5
# (可选) 犹豫/突出次数范围
@export var hesitation_count_min: int = 1
@export var hesitation_count_max: int = 3
# (可选) 每次犹豫时“缩回”的比例 (0 到 1)
@export var hesitation_retract_ratio: float = 0.3
# (可选) 每次犹豫的持续时间
@export var hesitation_duration: float = 0.2
# 门牙最终要接触到的中心 X 坐标 (用于区分左右)
@export var center_x_position: float = 0.0

# --- **修改**: 设置你的 DoorTooth 模型的 Y 轴基础长度 ---
@export var tooth_mesh_base_height: float = 1.5 # 当 scale.y = 1 时模型的Y轴长度
# --- **结束修改** ---


# --- 内部变量 ---
@onready var teeth_container: Node3D = $TeethContainer
@onready var closed_collision: StaticBody3D = $ClosedCollision
var trigger_area: Area3D = null

var teeth_left: Array[Node3D] = []
var teeth_right: Array[Node3D] = []
# --- **改回**: 存储 Y 轴 scale ---
var initial_scales_y: Dictionary = {} # 存储每个牙齿的初始 scale.y
var target_scales_y: Dictionary = {} # 存储每个牙齿的目标 scale.y
# --- **结束改回** ---
var is_closed: bool = false
var active_tweens: Array[Tween] = []
var retracted_scale_y: float = 0.1  # 门牙缩回时的 scale.y

@export var will_open: bool = false  # 如果为true，门初始关闭，触发时打开


func _ready():
	# 1. 验证内部节点
	if not is_instance_valid(teeth_container): push_error("SlidingDoor 未找到子节点 'TeethContainer'!"); return
	if not is_instance_valid(closed_collision): push_error("SlidingDoor 未找到子节点 'ClosedCollision'!"); return

	# 安全检查基础高度
	if tooth_mesh_base_height <= 0:
		push_error("'tooth_mesh_base_height' 必须大于 0!")
		tooth_mesh_base_height = 1.0 # 使用默认值

	# 2. 查找外部 TriggerArea 并连接信号 (同之前)
	for child in get_children():
		if child is Area3D:
			trigger_area = child
			break
	if not is_instance_valid(trigger_area):
		push_error("SlidingDoor 未在其子节点中找到 Area3D 触发器!")
	else:
		trigger_area.body_entered.connect(_on_trigger_area_body_entered, CONNECT_DEFERRED)
		print("SlidingDoor 已连接到触发器: ", trigger_area.name)

	# 4. 获取并区分左右门牙，记录初始 scale.y 和计算目标 scale.y
	for child in teeth_container.get_children():
		if child is Node3D:
			var initial_pos = child.position
			var initial_scale = child.scale
			initial_scales_y[child] = initial_scale.y # 只记录 Y

			# --- **计算需要沿 X 轴移动的距离** (用于计算 scale.y) ---
			var distance_to_center = abs(initial_pos.x - center_x_position)
			# --- **结束计算** ---

			# --- **修改**: 使用基础高度计算目标 scale.y ---
			var target_scale_y = distance_to_center / tooth_mesh_base_height
			# --- **结束修改** ---
			target_scales_y[child] = target_scale_y

			# 区分左右 (基于 X 坐标)
			if initial_pos.x < center_x_position:
				teeth_left.append(child)
			else:
				teeth_right.append(child)

			# --- **修改**: 根据 will_open 设置初始状态 ---
			if will_open:
				# 如果 will_open 为 true，门初始是关闭的（伸出）
				child.scale.y = target_scale_y
			else:
				# 否则门初始是打开的（缩回）
				child.scale.y = 0.1
			# --- **结束修改** ---


	# 5. 根据 will_open 设置初始碰撞和状态
	if will_open:
		# 门初始关闭，启用碰撞
		is_closed = true
		closed_collision.set_collision_layer_value(1, true)
		closed_collision.set_collision_mask_value(1, true)
	else:
		# 门初始打开，禁用碰撞
		is_closed = false
		closed_collision.set_collision_layer_value(1, false)
		closed_collision.set_collision_mask_value(1, false)


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

# --- ( close_door 函数，大部分逻辑改回 Y 轴 scale ) ---
func close_door():
	is_closed = true
	Wwise.post_event("SFX_door1", self)
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = false

	var all_teeth = teeth_left + teeth_right
	var max_tween_duration = 0.0

	for tooth in all_teeth:
		if not initial_scales_y.has(tooth) or not target_scales_y.has(tooth): continue

		var start_scale_y: float = tooth.scale.y # 当前 scale.y (应该是 0.1)
		var target_scale_y: float = target_scales_y[tooth]
		var scale_difference = target_scale_y - start_scale_y

		if scale_difference < 0.01: continue

		var random_speed = randf_range(random_speed_min, random_speed_max)
		var base_duration = scale_difference / random_speed if random_speed > 0 else 999.0

		var tween = create_tween()
		active_tweens.append(tween)

		var current_duration = 0.0
		var current_scale_y = start_scale_y
		var initial_scale_y_for_retract = 0.1

		# 添加随机“犹豫”动作 (基于 scale.y)
		var hesitation_count = randi_range(hesitation_count_min, hesitation_count_max)
		for i in range(hesitation_count):
			# 1. 向目标 scale.y 移动一小段
			var scale_ratio = (1.0 - hesitation_retract_ratio) / hesitation_count
			var partial_target_scale_y = lerp(current_scale_y, target_scale_y, scale_ratio)
			var partial_duration = max(0.001, base_duration * scale_ratio)
			# --- **改回**: 只动画 scale:y ---
			tween.tween_property(tooth, "scale:y", partial_target_scale_y, partial_duration).set_trans(Tween.TRANS_LINEAR)
			# --- **结束改回** ---
			current_duration += partial_duration
			current_scale_y = partial_target_scale_y

			# 2. 稍微缩回一点 (scale.y 变小)
			var retract_target_scale_y = lerp(current_scale_y, initial_scale_y_for_retract, hesitation_retract_ratio)
			var actual_hesitation_duration = max(0.001, hesitation_duration)
			# --- **改回**: 只动画 scale:y ---
			tween.tween_property(tooth, "scale:y", retract_target_scale_y, actual_hesitation_duration).set_trans(Tween.TRANS_SINE)
			# --- **结束改回** ---
			current_duration += actual_hesitation_duration
			current_scale_y = retract_target_scale_y

		# 最后一段：移动到最终目标 scale.y
		var final_scale_diff = target_scale_y - current_scale_y
		var remaining_ratio = final_scale_diff / scale_difference if scale_difference > 0 else 0
		var final_duration = max(0.001, base_duration * remaining_ratio)
		# --- **改回**: 只动画 scale:y ---
		tween.tween_property(tooth, "scale:y", target_scale_y, final_duration).set_trans(Tween.TRANS_LINEAR)
		# --- **结束改回** ---
		current_duration += final_duration

		if current_duration > max_tween_duration:
			max_tween_duration = current_duration

	# 等待最长的动画结束 (同之前)
	if all_teeth.is_empty():
		_enable_closed_collision()
	else:
		get_tree().create_timer(max_tween_duration).timeout.connect(_enable_closed_collision)


# --- ( _enable_closed_collision 保持不变, 修改打印信息 ) ---
func _enable_closed_collision():
	if not is_instance_valid(closed_collision): return
	closed_collision.set_collision_layer_value(1, true)
	closed_collision.set_collision_mask_value(1, true)
	print("滑动门(Scale Y)已关闭") # <-- 修改打印信息
	active_tweens.clear()

# --- ( _exit_tree 保持不变 ) ---
func _exit_tree():
	for tween in active_tweens:
		if tween:
			tween.kill()
	active_tweens.clear()


func open_door():
	"""打开门，将所有门牙缩回到初始位置"""
	if not is_closed:
		return  # 门已经是开着的
	Wwise.post_event("SFX_door1", self)
	is_closed = false
	
	# 禁用关闭碰撞体
	if is_instance_valid(closed_collision):
		closed_collision.set_collision_layer_value(1, false)
		closed_collision.set_collision_mask_value(1, false)
	
	# 重新启用触发器（可选）
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = true
	
	# 停止所有活动的 tween
	for tween in active_tweens:
		if tween:
			tween.kill()
	active_tweens.clear()
	
	var all_teeth = teeth_left + teeth_right
	var max_tween_duration = 0.0
	
	for tooth in all_teeth:
		var current_scale_y = tooth.scale.y
		var target_retracted_scale_y = retracted_scale_y
		var scale_difference = abs(current_scale_y - target_retracted_scale_y)
		
		if scale_difference < 0.01:
			continue
		
		# 使用随机速度计算缩回时间
		var random_speed = randf_range(random_speed_min, random_speed_max)
		var retract_duration = scale_difference / random_speed if random_speed > 0 else 1.0
		
		var tween = create_tween()
		active_tweens.append(tween)
		
		# 缩回到初始 scale.y
		tween.tween_property(tooth, "scale:y", target_retracted_scale_y, retract_duration)\
			 .set_trans(Tween.TRANS_SINE)\
			 .set_ease(Tween.EASE_IN_OUT)
		
		if retract_duration > max_tween_duration:
			max_tween_duration = retract_duration
	
	# 等待所有动画完成
	if not all_teeth.is_empty():
		get_tree().create_timer(max_tween_duration).timeout.connect(func():
			print("滑动门(Scale Y)已打开")
			active_tweens.clear()
		)
	else:
		print("滑动门(Scale Y)已打开")
