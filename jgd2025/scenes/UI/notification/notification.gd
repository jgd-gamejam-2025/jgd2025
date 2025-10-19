extends CanvasLayer

@onready var timer = $Timer
@onready var name_label = %Label
@onready var message_label = %RichTextLabel
@onready var box = $CenterContainer
var show_pos
var hide_pos
var _tween : Tween

func _ready() -> void:
	show_pos = box.position  # Store original position first
	hide_pos = Vector2(box.position.x, box.position.y + 200)
	box.position = hide_pos

func show_notification(message: String, duration: float = 3.0, name_text: String = "Eve") -> void:
	name_label.text = name_text
	message_label.text = message
	timer.wait_time = duration
	timer.start()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(box, "position:y", show_pos.y, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func end_notification() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(box, "position:y", hide_pos.y, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	timer.stop()

func _on_timer_timeout() -> void:
	end_notification()
