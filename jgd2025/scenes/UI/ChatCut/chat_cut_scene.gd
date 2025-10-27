extends CanvasLayer

@onready var label1 = $ChatUI/Panel/Name
@onready var label2 = $ChatUI/Panel/Name2
@onready var img1 = $ChatUI/Panel/ProfilePic/ImageFrame/Eve
@onready var img2 = $ChatUI/Panel/ProfilePic/ImageFrame/Eve2
@onready var bg = $ChatUI/Panel/Background
@onready var input_field = $ChatUI/Panel/InputHBox/TextInput
func _ready() -> void:
	label1.visible = true
	label2.visible = false
	img1.visible = true
	img2.visible = false
	var flip_speed = 0.5
	var flip_count = 0
	var max_flips = 21
	
	await get_tree().create_timer(3.0)
	Transition.end()

	var tween = create_tween()
	tween.tween_property(bg, "color", Color.BLACK, 3.0)

	while flip_count < max_flips:
		await get_tree().create_timer(flip_speed).timeout
		label1.visible = !label1.visible
		label2.visible = !label2.visible
		img1.visible = !img1.visible
		img2.visible = !img2.visible
		flip_speed *= 0.8
		flip_count += 1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

var target_text = "我恨你"

var delete_timer_cap = 0.5
var delete_timer = 0
func _process(_delta: float) -> void:
	var current_text = input_field.text
	
	if current_text == target_text:
		return
	
	if current_text.length() > 0 and current_text != target_text:
		if not target_text.begins_with(current_text):
			delete_timer += _delta
			if delete_timer >= delete_timer_cap:
				input_field.text = current_text.substr(0, current_text.length() - 1)
				delete_timer = 0
		else:
			delete_timer = 0
	else:
		delete_timer = 0


func _type_target_text() -> void:
	input_field.text = ""
	for char in target_text:
		input_field.text += char
		await get_tree().create_timer(0.05).timeout
	input_field.editable = true


func _on_text_input_text_submitted(new_text: String) -> void:
	if input_field.text != target_text:
		input_field.editable = false
		await _type_target_text()
		# get_tree().root.set_input_as_handled()
	await get_tree().create_timer(1.5).timeout
	# proceed to next scene
	Transition.set_and_start("", "",0, "N/A")
	await get_tree().create_timer(0.5).timeout
	Wwise.stop_all(LevelManager)
	LevelManager.to_room()
