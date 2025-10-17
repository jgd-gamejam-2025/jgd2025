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

# 平滑系数，用于减缓移动
@export var smooth_speed := 6.0

var is_playing = false

var _current_t := 0.0

func _process(delta: float) -> void:
	if not camera_pivot:
		return

	# 获取相机俯仰角（x为pitch，低头是负值）
	var pitch := camera_pivot.rotation_degrees.x

	# 计算插值比例 t：在 move_when_angle 到 move_until_angle 之间映射为 0~1
	var t := (pitch - move_when_angle) / (move_until_angle - move_when_angle)
	t = clamp(t, 0.0, 1.0)

	# 使用 smoothstep 让动画更顺滑
	t = smoothstep(0.0, 1.0, t)

	# 可选：用线性插值平滑过渡
	_current_t = lerp(_current_t, t, delta * smooth_speed)

	# 插值位置与旋转
	position = start_position.lerp(end_position, _current_t)
	rotation_degrees = start_rotation.lerp(end_rotation, _current_t)
	
	# Check for pad activation
	if is_playing:
		if Input.is_action_just_pressed("ui_cancel"):  # Enter esc
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
