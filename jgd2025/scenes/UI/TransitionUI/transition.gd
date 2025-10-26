extends CanvasLayer

@onready var bg_text = "雨"
@onready var center_text = "雨"
@export var exist_time = 1.0
@onready var bg = $BG
@onready var center_label = $Label

@export var wwise_loading :WwiseEvent

var _tween: Tween

func start(wait_time: float = 0.0) -> Tween:
	show()
	wwise_loading.post(self)
	$AudioStreamPlayer.play()
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	if wait_time > 0.0:
		_tween.tween_interval(wait_time)
		_tween.tween_callback(func():
			end()
		)
	return _tween

func end():
	$AudioStreamPlayer.stop()
	wwise_loading.stop(self)
	hide()

func _ready() -> void:
	set_text(bg_text, center_text)
	hide()

func set_text(new_center_text: String, new_bg_text: String) -> void:
	bg_text = new_bg_text
	center_label.text = new_center_text
	var tmp = ""
	for j in range(16):
		tmp += bg_text
	for i in bg.get_children():
		if i is Label:
			i.text = tmp

func set_bg_color(new_color: Color) -> void:
	ColorRect.color = new_color

func set_and_start(new_bg_text: String, new_center_text: String, wait_time: float = 0.0, audio_clip: AudioStream= null) -> Tween:
	$EVE.hide()
	$AudioStreamPlayer.stream = audio_clip
	set_text(new_bg_text, new_center_text)
	return start(wait_time)

func show_EVE():
	$EVE.show()
	show()
	await get_tree().create_timer(2).timeout
	$EVE/Label.show()
