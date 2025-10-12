extends Node

@onready var chat_ui = $ChatUI
var text_sent_count = 0

func _ready():
	chat_ui.set_ai_name("Eve")
	chat_ui.show_text_gradually("……", 0.1)
	chat_ui.set_system_prompt(
		"你扮演一个失去记忆的AI助手，你很虚弱，没有任何记忆。你的回答必须简短，不超过10个字。"
	)
	chat_ui.start_chat_worker()
