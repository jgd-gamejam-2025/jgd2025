extends Node

@onready var chat_ui = $ChatUI
var text_sent_count = 0
#@export var next_level: PackedScene

func _ready():
	chat_ui.set_ai_name("Eve")
	chat_ui.show_text_gradually("……", 0.1)
	chat_ui.set_system_prompt(
		"你扮演一个失去记忆的AI助手，你很虚弱，没有任何记忆。你的回答必须简短，不超过10个字。"
	)
	chat_ui.start_chat_worker()
	Transition.end()


func _on_chat_ui_sent_text() -> void:
	text_sent_count += 1
	if text_sent_count == 2:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var tween = Transition.set_and_start("结局中", "结局", 3)
		await tween.finished
		Transition.set_and_start("结局", "")
		#await get_tree().create_timer(0.7).timeout
		#get_tree().change_scene_to_packed(next_level)
