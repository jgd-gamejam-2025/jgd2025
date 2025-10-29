extends CanvasLayer

@onready var curr_ai_level_label = $ColorRect/MarginContainer2/VBoxContainer/Label2
@onready var ai_description = $ColorRect/MarginContainer2/VBoxContainer/AiSwitch/RichTextLabel

func _ready() -> void:
	set_ai_level_label()
	if LevelManager.end_of_game:
		$ColorRect/MarginContainer/VBoxContainer/EndingChat.show()
	Wwise.stop_all()
	Wwise.post_event("MX_Play_begin", LevelManager)
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_property($ColorRect/Image, "modulate:a", 1, 1.0)

	if not LevelManager.has_save():
		$ColorRect/MarginContainer/VBoxContainer/Continue.hide()
		
var clicked_button = false
func _on_continue_pressed() -> void:
	if clicked_button:
		return
	Wwise.post_event("UI_Choose", LevelManager)
	clicked_button = true
	await get_tree().create_timer(0.2).timeout
	Transition.set_and_start("正在连接……", "", 2)
	LevelManager.in_menu = true
	LevelManager.load_game()


func _on_new_game_pressed() -> void:
	if clicked_button:
		return
	Wwise.post_event("UI_Choose", LevelManager)
	clicked_button = true
	await get_tree().create_timer(0.2).timeout
	Transition.set_and_start("正在连接……", "", 2)
	LevelManager.in_menu = true
	LevelManager.to_chat_1()


func _on_exit_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)
	get_tree().quit()


func _on_continue_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)


func _on_options_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)
	OptionsSettings.show()


func _on_options_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)


func _on_ai_switch_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)
	if LevelManager.ai_level == 0:
		LevelManager.ai_level = 1
	else:
		LevelManager.ai_level = 0
	LevelManager.save_use_low_ai(LevelManager.ai_level)
	set_ai_level_label()

func set_ai_level_label() -> void:
	if LevelManager.ai_level == 0:
		curr_ai_level_label.text = "当前AI智力：有限"
	else:
		curr_ai_level_label.text = "当前AI智力：标准"
		
func _on_ai_switch_mouse_entered() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)
	ai_description.show()

func _on_ai_switch_mouse_exited() -> void:
	ai_description.hide()

func _on_ending_chat_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)
	Wwise.stop_all()
	LevelManager.to_end_chat()
