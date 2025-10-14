extends Control

@onready var chatLog = $Panel/Scroll/ChatLog
@onready var textInput = $Panel/InputHBox/TextInput
@onready var aiChat = $NobodyWhoChat
@onready var name_label = $Panel/Name

var _tween: Tween 
var block_text_generation = false

signal sent_text
signal line_edit_focus
var line_edit_focus_sent = false

func _ready() -> void:
	# textInput.grab_focus()
	pass

func send_text_to_ai():
	textInput.editable = false
	chatLog.text = ""
	aiChat.say(textInput.text)
	sent_text.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		await get_tree().process_frame  # 等一帧，让 UI 渲染完成
		textInput.grab_focus()

	if event.is_action_pressed("ui_text_newline") and textInput.editable and textInput.text != "":
		send_text_to_ai()

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

func show_welcome_text(full_text: String, interval: float = 0.05, overwrite:bool = true) -> void:
	if _tween:
		_tween.kill() # Stop any existing animation
	
	var pre_text = ""
	if not overwrite:
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
