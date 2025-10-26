extends CanvasLayer

@onready var timer = $Timer
@onready var name_label = %Label
@onready var message_label = %RichTextLabel
@onready var box = $CenterContainer
@onready var profile_pic = %ProfilePic
@onready var panel_container = $CenterContainer/PanelContainer
var show_pos
var hide_pos
var _tween : Tween

func _ready() -> void:
	show_pos = box.position  # Store original position first
	hide_pos = Vector2(box.position.x, box.position.y + 1000)
	box.position = hide_pos

func show_notification(message: String, duration: float = 3.0, name_text: String = name_label.text) -> void:
	name_label.text = name_text
	message_label.text = message
	timer.wait_time = duration
	timer.start()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	box.position.y = hide_pos.y  # Ensure starting from hidden position
	_tween.tween_property(box, "position:y", show_pos.y, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func end_notification() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(box, "position:y", hide_pos.y, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	timer.stop()

func _on_timer_timeout() -> void:
	end_notification()

func set_bg_color(color: Color) -> void:
	# Get the current StyleBox from the panel
	var style_box = panel_container.get_theme_stylebox("panel")
	
	# If it's a StyleBoxFlat, we can modify it directly
	if style_box is StyleBoxFlat:
		style_box.bg_color = color
	else:
		# Create a new StyleBoxFlat if the current one isn't editable
		var new_style = StyleBoxFlat.new()
		new_style.bg_color = color
		new_style.corner_radius_top_left = 40
		new_style.corner_radius_top_right = 40
		new_style.corner_radius_bottom_right = 40
		new_style.corner_radius_bottom_left = 40
		panel_container.add_theme_stylebox_override("panel", new_style)
