extends MeshInstance3D

signal pad_activated  # Signal when pad is activated
signal pad_deactivated  # Signal when pad is deactivated

@export var camera_pivot: Node3D
@export var move_when_angle := -26.0	# 开始抬起的角度
@export var move_until_angle := -45.0	# 完全举起的角度
@export var activation_threshold := 0.8  # How close to max angle needed to activate

@export var start_position: Vector3 = Vector3(0.4, -0.5, 0.8)
@export var start_rotation: Vector3 = Vector3(-10, 0, 0)
@export var end_position: Vector3 = Vector3(0.3, -0.2, 0.4)
@export var end_rotation: Vector3 = Vector3(30, 0, 0)

@onready var viewport_ui = $SubViewport

@onready var chat_ui = %ChatUI

@onready var player: CharacterBody3D = owner

# 平滑系数，用于减缓移动
@export var smooth_speed := 6.0
@export var wwise_out :WwiseEvent
@export var wwise_in :WwiseEvent


var is_playing = false

var _current_t := 0.0

var follow_player := true

var _was_above_threshold := false  # 记录上一帧是否超过阈值

var can_activate := true

func _process(delta: float) -> void:
	if not follow_player or not camera_pivot or not player: # 确保 player 也被正确获取
		return

	var t: float # 先声明 t

	# --- 这是主要的修改 ---
	if can_activate and player.is_on_floor():
		# 玩家在地上：正常根据视角计算 t
		var pitch := camera_pivot.rotation_degrees.x
		t = (pitch - move_when_angle) / (move_until_angle - move_when_angle)
		t = clamp(t, 0.0, 1.0)
		t = smoothstep(0.0, 1.0, t)
	else:
		# 玩家在空中：强制 t = 0，让 Pad 收回
		t = 0.0
	# --- 修改结束 ---
	
	# 可选：用线性插值平滑过渡
	_current_t = lerp(_current_t, t, delta * smooth_speed)

	# 插值位置与旋转
	position = start_position.lerp(end_position, _current_t)
	rotation_degrees = start_rotation.lerp(end_rotation, _current_t)
	
	# 检测阈值变化并播放音效（只播放一次）
	var is_above_threshold = _current_t >= activation_threshold
	if is_above_threshold != _was_above_threshold:
		if is_above_threshold:
			# 刚超过阈值，播放 wwise_out
			if wwise_out:
				wwise_out.post(player)
		else:
			# 刚低于阈值，播放 wwise_in
			if wwise_in:
				wwise_in.post(player)
		_was_above_threshold = is_above_threshold
	
	# Check for pad activation
	# (后面的激活检测逻辑保持不变，因为 t = 0 会自动处理掉激活状态)
	if is_playing:
		if Input.is_action_just_pressed("ui_cancel") || _current_t < activation_threshold:  # Enter esc
			is_playing = false
			pad_deactivated.emit()
			stop_pad()
	elif _current_t >= activation_threshold:
		if Input.is_action_just_pressed("ui_accept"):  # Enter key
			is_playing = true
			pad_activated.emit()
			play_pad()

func _unhandled_input(event):
	# 将全局输入事件转发给 SubViewport
	if is_playing:
		viewport_ui.push_input(event, false)		

func play_pad() -> void:
	chat_ui.textInput.grab_focus()

func stop_pad() -> void:
	chat_ui.textInput.release_focus()
