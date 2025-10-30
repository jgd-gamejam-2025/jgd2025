extends CanvasLayer
@onready var texture_rect = $TextureRect
@onready var label = $Control/Label
@onready var label2 = $Control/Label2
@onready var label3 = $Control/Label3
@onready var label4 = $Control/Label4
@onready var label5 = $Control/Label5
@onready var vbox_container = $Control/VBoxContainer
@onready var button = $Control/VBoxContainer/Button
@onready var button2 = $Control/VBoxContainer/Button2
@onready var button3 = $Control/VBoxContainer/Button3

func _ready() -> void:
	label.modulate.a = 0
	label2.modulate.a = 0
	label3.modulate.a = 0
	label4.modulate.a = 0
	label5.modulate.a = 0
	texture_rect.modulate.a = 0
	vbox_container.hide()
	Transition.set_and_start("还记得吗？", "《流体恋人》", 4.0, "N/A")

	var tween = create_tween()
	tween.tween_interval(7)
	tween.tween_property(texture_rect, "modulate:a", 1, 1.0)
	# tween.tween_interval(2.5)
	# tween.tween_property(label, "modulate:a", 1, 1.0)
	# tween.tween_interval(2.5)
	# tween.tween_property(label2, "modulate:a", 1, 1.0)
	# tween.tween_interval(2.5)
	# tween.tween_property(label3, "modulate:a", 1, 1.0)
	# tween.tween_interval(1)
	# tween.tween_property(label4, "modulate:a", 1, 1.0)
	# tween.tween_interval(1)
	# tween.tween_property(label5, "modulate:a", 1, 1.0)
	tween.tween_interval(3)
	tween.tween_callback(
		func():
			vbox_container.show()
			await get_tree().process_frame
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	)


signal ended
func end():
	print("End Room Opening Scene")
	await get_tree().process_frame
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	ended.emit()


func _on_button_pressed() -> void:
	# Wwise.post_event("UI_Choose", LevelManager)
	end()

func _on_button_2_pressed() -> void:
	# Wwise.post_event("UI_Choose", LevelManager)
	end()

func _on_button_3_pressed() -> void:
	# Wwise.post_event("UI_Choose", LevelManager)
	end()

func _on_button_3_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)
	button3.text = "我不在乎"

func _on_button_2_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)
	button2.text = "我不在乎"

func _on_button_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)
	button.text = "我不在乎"
