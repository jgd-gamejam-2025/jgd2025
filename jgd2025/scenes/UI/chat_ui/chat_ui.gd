extends Control

@onready var chatLog = $Panel/Scroll/ChatLog
@onready var textInput = $Panel/InputHBox/TextInput
@onready var aiChat = $NobodyWhoChat
@onready var name_label = $Panel/Name
@export var debug_mode = false

var _tween: Tween 
var block_text_generation = false

signal sent_text
signal line_edit_focus
var line_edit_focus_sent = false
var first_time_sent_text = true

func _ready() -> void:
	if debug_mode:
		print("Debug mode activated")

func send_text_to_ai():
	textInput.editable = false
	chatLog.text = ""
	if not debug_mode:
		aiChat.say(textInput.text)
	else:
		_on_nobody_who_chat_response_updated("Debugging...")
		_on_nobody_who_chat_response_finished("Debugging Again")
	sent_text.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		await get_tree().process_frame  # 等一帧，让 UI 渲染完成
		textInput.grab_focus()

	if event.is_action_pressed("ui_text_newline") and textInput.editable and textInput.text != "":
		send_text_to_ai()
		if first_time_sent_text:
			first_time_sent_text = false
			to_chat_mode()

func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	if block_text_generation:
		return
	chatLog.text += new_token

func _on_nobody_who_chat_response_finished(response: String) -> void:
	if block_text_generation:
		return
	textInput.editable = true
	textInput.text = ""
	# focus the text input for next message
	textInput.grab_focus()

func show_text_gradually(full_text: String, interval: float = 0.05, empty_text:bool = true) -> void:
	if _tween:
		_tween.kill() # Stop any existing animation
	
	var pre_text = ""
	if not empty_text:
		pre_text = chatLog.text
	
	_tween = create_tween()
	var char_count := full_text.length()
	var total_time := interval * char_count
	
	# Create a tween that goes from 0 to total characters
	_tween.tween_method(
		func(current_char: float):
			var char_index = int(current_char)
			chatLog.text = pre_text + full_text.substr(0, char_index),
		0.0,  # Start with 0 characters
		float(char_count),  # End with all characters
		total_time  # Total animation time
	)

func set_system_prompt(prompt: String) -> void:
	aiChat.system_prompt = prompt
	
func start_chat_worker():
	aiChat.start_worker()

func set_ai_name(new_name: String) -> void:
	name_label.text = new_name
	
func _on_text_input_focus_entered() -> void:
	if not line_edit_focus_sent:
		line_edit_focus_sent = true
		line_edit_focus.emit()

func to_chat_mode():
	var input_hbox = $Panel/InputHBox
	var profile_pic = $Panel/ProfilePic
	var name_tag = $Panel/Name

	var tween = create_tween()
	var viewport_size = get_viewport().get_visible_rect().size
	tween.set_parallel()
	tween.tween_property(input_hbox, "position:y", viewport_size.y - input_hbox.size.y - 35, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(profile_pic, "position:y", 25, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(profile_pic, "scale", Vector2(0.35, 0.35), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(name_tag, "position:y", 115, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	kill_text_animation()

func kill_text_animation(interval: float = 0.02) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	var full_text = chatLog.text
	var char_count = full_text.length()
	var total_time = interval * char_count
	_tween.tween_method(
		func(current_char: float):
			var char_index = char_count - int(current_char)
			chatLog.text = full_text.substr(0, char_index),
		0.0,  # Start with 0 characters
		float(char_count),  # End with all characters
		total_time  # Total animation time
	)
