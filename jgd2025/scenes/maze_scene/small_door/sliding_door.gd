# SlidingDoor.gd
extends Node3D

@export_group("动画设置")
# 门牙完全伸出到位所需的“大概”时间 (现在这个参数将被实际使用)
@export var close_duration: float = 1.9 # 关门的总时长
# 门牙完全缩回到位所需的“大概”时间 (新参数，用于开门的总时长)
@export var open_duration: float = 1.0 # 开门的总时长
# 每个门牙伸出速度的随机范围 (比例/秒)
@export var random_speed_min: float = 0.8 # 调整范围，确保不会过慢或过快
@export var random_speed_max: float = 1.2
# (可选) 犹豫/突出次数范围
@export var hesitation_count_min: int = 1
@export var hesitation_count_max: int = 3
# (可选) 每次犹豫时“缩回”的比例 (0 到 1)
@export var hesitation_retract_ratio: float = 0.3
# (可选) 每次犹豫的持续时间 (现在按比例于 close_duration / open_duration)
@export var hesitation_duration_ratio: float = 0.05 # 每次犹豫占总时长的比例
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
var initial_scales_y: Dictionary = {} # 存储每个牙齿的初始 scale.y (门开着时的 scale.y)
var target_scales_y: Dictionary = {} # 存储每个牙齿的目标 scale.y (门关着时的 scale.y)
var is_closed: bool = false
var active_tweens: Array[Tween] = []
var retracted_scale_y: float = 0.1 # 门牙缩回时的 scale.y

@export var will_open: bool = false # 如果为true，门初始关闭，触发时打开


func _ready():
	# 1. 验证内部节点
	if not is_instance_valid(teeth_container): push_error("SlidingDoor 未找到子节点 'TeethContainer'!"); return
	if not is_instance_valid(closed_collision): push_error("SlidingDoor 未找到子节点 'ClosedCollision'!"); return

	# 安全检查基础高度
	if tooth_mesh_base_height <= 0:
		push_error("'tooth_mesh_base_height' 必须大于 0!")
		tooth_mesh_base_height = 1.0 # 使用默认值

	# 2. 查找外部 TriggerArea 并连接信号
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
			
			initial_scales_y[child] = retracted_scale_y # 门开着时的实际 scale.y
			
			var distance_to_center = abs(initial_pos.x - center_x_position)
			var target_scale_y_for_closed = distance_to_center / tooth_mesh_base_height
			target_scales_y[child] = target_scale_y_for_closed

			# 区分左右 (基于 X 坐标)
			if initial_pos.x < center_x_position:
				teeth_left.append(child)
			else:
				teeth_right.append(child)

			# 根据 will_open 设置初始状态
			if will_open:
				# 如果 will_open 为 true，门初始是关闭的（伸出）
				child.scale.y = target_scale_y_for_closed
			else:
				# 否则门初始是打开的（缩回）
				child.scale.y = retracted_scale_y


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

func close_door():
	"""关闭门，将所有门牙伸出到位"""
	if is_closed: return # 门已经是关闭的了

	is_closed = true
	Wwise.post_event("SFX_door1", self)
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = false # 门关闭时禁用触发器

	var all_teeth = teeth_left + teeth_right
	if all_teeth.is_empty():
		_enable_closed_collision()
		return

	for tween in active_tweens:
		if tween: tween.kill()
	active_tweens.clear()

	for tooth in all_teeth:
		if not initial_scales_y.has(tooth) or not target_scales_y.has(tooth): continue

		var start_scale_y: float = tooth.scale.y
		var target_scale_y: float = target_scales_y[tooth]
		var scale_range_for_this_tooth = abs(target_scale_y - initial_scales_y[tooth])
		
		if scale_range_for_this_tooth < 0.001: continue

		var tween = create_tween()
		active_tweens.append(tween)
		
		var random_speed_factor = randf_range(random_speed_min, random_speed_max)
		
		var current_tween_total_time = 0.0

		var initial_segment_duration = (start_scale_y - initial_scales_y[tooth]) / scale_range_for_this_tooth * close_duration * random_speed_factor if scale_range_for_this_tooth > 0 else 0
		if initial_segment_duration > 0.01:
			tween.tween_property(tooth, "scale:y", start_scale_y, initial_segment_duration)
			current_tween_total_time += initial_segment_duration
			
		var hesitation_count = randi_range(hesitation_count_min, hesitation_count_max)
		
		var total_hesitation_time = hesitation_count * (hesitation_duration_ratio * close_duration) * random_speed_factor
		var main_movement_time = (close_duration * random_speed_factor) - total_hesitation_time
		
		var single_hesitation_full_duration = (hesitation_duration_ratio * close_duration) * random_speed_factor
		
		var current_animated_scale_y = start_scale_y

		for i in range(hesitation_count):
			var move_segment_duration = max(0.001, single_hesitation_full_duration * (1.0 - hesitation_retract_ratio))
			var partial_target_scale_y = lerp(current_animated_scale_y, target_scale_y, (1.0 - hesitation_retract_ratio) / hesitation_count)
			
			tween.tween_property(tooth, "scale:y", partial_target_scale_y, move_segment_duration)\
				.set_trans(Tween.TRANS_LINEAR)\
				.set_delay(current_tween_total_time)
			current_tween_total_time += move_segment_duration
			current_animated_scale_y = partial_target_scale_y

			var retract_segment_duration = max(0.001, single_hesitation_full_duration * hesitation_retract_ratio)
			var retract_target_scale_y = lerp(current_animated_scale_y, retracted_scale_y, hesitation_retract_ratio)
			
			tween.tween_property(tooth, "scale:y", retract_target_scale_y, retract_segment_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_delay(current_tween_total_time)
			current_tween_total_time += retract_segment_duration
			current_animated_scale_y = retract_target_scale_y
		
		var final_segment_duration = max(0.001, main_movement_time - initial_segment_duration)
		
		tween.tween_property(tooth, "scale:y", target_scale_y, final_segment_duration)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_delay(current_tween_total_time)
		current_tween_total_time += final_segment_duration

		tooth.set_meta("final_close_tween_time", current_tween_total_time)

	var max_final_tween_time = 0.0
	for tooth in all_teeth:
		if tooth.has_meta("final_close_tween_time"):
			max_final_tween_time = max(max_final_tween_time, tooth.get_meta("final_close_tween_time"))

	get_tree().create_timer(max_final_tween_time).timeout.connect(_enable_closed_collision)


func _enable_closed_collision():
	if not is_instance_valid(closed_collision): return
	closed_collision.set_collision_layer_value(1, true)
	closed_collision.set_collision_mask_value(1, true)
	print("滑动门(Scale Y)已关闭")
	active_tweens.clear()

func _exit_tree():
	for tween in active_tweens:
		if tween:
			tween.kill()
	active_tweens.clear()


func open_door():
	"""打开门，将所有门牙缩回到初始位置，并带有犹豫和错落机制"""
	if not is_closed:
		return  # 门已经是开着的
	Wwise.post_event("SFX_door1", self)
	is_closed = false
	
	if is_instance_valid(closed_collision):
		closed_collision.set_collision_layer_value(1, false)
		closed_collision.set_collision_mask_value(1, false)
	
	if is_instance_valid(trigger_area):
		trigger_area.monitoring = true # 门打开时重新启用触发器
	
	for tween in active_tweens:
		if tween: tween.kill()
	active_tweens.clear()
	
	var all_teeth = teeth_left + teeth_right
	if all_teeth.is_empty(): # 如果没有牙齿，直接返回
		print("滑动门(Scale Y)已打开")
		return

	for tooth in all_teeth:
		var start_scale_y: float = tooth.scale.y # 当前 scale.y (应该是目标关闭时的 scale.y)
		var target_scale_y: float = retracted_scale_y # 目标是缩回状态
		var scale_range_for_this_tooth = abs(target_scales_y[tooth] - retracted_scale_y) # 从完全伸出到完全缩回的总范围
		
		if scale_range_for_this_tooth < 0.001: continue # 如果牙齿不需移动，跳过

		var tween = create_tween()
		active_tweens.append(tween)
		
		var random_speed_factor = randf_range(random_speed_min, random_speed_max)
		
		var current_tween_total_time = 0.0
		
		# 首先，确保门牙从当前状态平滑过渡到目标动画的起始点
		# 如果门牙已经部分缩回，我们从当前位置开始
		var initial_segment_duration = (target_scales_y[tooth] - start_scale_y) / scale_range_for_this_tooth * open_duration * random_speed_factor if scale_range_for_this_tooth > 0 else 0
		if initial_segment_duration > 0.01: # 避免不必要的短动画
			tween.tween_property(tooth, "scale:y", start_scale_y, initial_segment_duration)
			current_tween_total_time += initial_segment_duration
			
		var hesitation_count = randi_range(hesitation_count_min, hesitation_count_max)
		
		var total_hesitation_time = hesitation_count * (hesitation_duration_ratio * open_duration) * random_speed_factor
		var main_movement_time = (open_duration * random_speed_factor) - total_hesitation_time
		
		var single_hesitation_full_duration = (hesitation_duration_ratio * open_duration) * random_speed_factor
		
		var current_animated_scale_y = start_scale_y # 从当前牙齿的实际 scale.y 开始动画

		for i in range(hesitation_count):
			# 1. 向目标 scale.y 移动一小段 (缩回)
			var move_segment_duration = max(0.001, single_hesitation_full_duration * (1.0 - hesitation_retract_ratio))
			var partial_target_scale_y = lerp(current_animated_scale_y, target_scale_y, (1.0 - hesitation_retract_ratio) / hesitation_count)
			
			tween.tween_property(tooth, "scale:y", partial_target_scale_y, move_segment_duration)\
				.set_trans(Tween.TRANS_LINEAR)\
				.set_delay(current_tween_total_time)
			current_tween_total_time += move_segment_duration
			current_animated_scale_y = partial_target_scale_y

			# 2. 稍微“突出”一点 (scale.y 变大)
			var extend_segment_duration = max(0.001, single_hesitation_full_duration * hesitation_retract_ratio)
			# 注意这里 lerp 的目标是 target_scales_y[tooth] (完全伸出时的 scale.y)
			var extend_target_scale_y = lerp(current_animated_scale_y, target_scales_y[tooth], hesitation_retract_ratio) 
			
			tween.tween_property(tooth, "scale:y", extend_target_scale_y, extend_segment_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_delay(current_tween_total_time)
			current_tween_total_time += extend_segment_duration
			current_animated_scale_y = extend_target_scale_y
		
		# 最后一段：移动到最终目标 scale.y (完全缩回)
		var final_segment_duration = max(0.001, main_movement_time - initial_segment_duration)
		
		tween.tween_property(tooth, "scale:y", target_scale_y, final_segment_duration)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_delay(current_tween_total_time)
		current_tween_total_time += final_segment_duration

		# 记录每个牙齿的最终动画时间，用于判断何时打印“门已打开”
		tooth.set_meta("final_open_tween_time", current_tween_total_time)

	# 找到最长的动画时间，然后延迟打印信息
	var max_final_tween_time = 0.0
	for tooth in all_teeth:
		if tooth.has_meta("final_open_tween_time"):
			max_final_tween_time = max(max_final_tween_time, tooth.get_meta("final_open_tween_time"))

	get_tree().create_timer(max_final_tween_time).timeout.connect(func():
		print("滑动门(Scale Y)已打开")
		active_tweens.clear() # 清空活跃的 tweens
	)
