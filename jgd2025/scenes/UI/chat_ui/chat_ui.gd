extends Control

@onready var chatLog = $Panel/Scroll/ChatLog
@onready var textInput = $Panel/InputHBox/TextInput
@onready var aiChat = $NobodyWhoChat
@onready var name_label = $Panel/Name

signal sent_text

func _ready() -> void:
	textInput.grab_focus()

func send_text_to_ai():
	textInput.editable = false
	chatLog.text = ""
	aiChat.say(textInput.text)
	sent_text.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_newline") and textInput.editable and textInput.text != "":
		send_text_to_ai()

func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	chatLog.text += new_token

func _on_nobody_who_chat_response_finished(response: String) -> void:
	textInput.editable = true
	textInput.text = ""
	# focus the text input for next message
	textInput.grab_focus()

func show_text_gradually(full_text: String, interval: float = 0.05) -> void:
	chatLog.text = ""
	var char_index := 0
	var char_count := full_text.length()
	while char_index < char_count:
		chatLog.text += full_text[char_index]
		char_index += 1
		await get_tree().create_timer(interval).timeout

func set_system_prompt(prompt: String) -> void:
	aiChat.system_prompt = prompt
	
func start_chat_worker():
	aiChat.start_worker()

func set_ai_name(new_name: String) -> void:
	name_label.text = new_name
