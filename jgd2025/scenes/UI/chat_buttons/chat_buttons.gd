extends CanvasLayer

@export var is_3d_scene = false

func _ready():
	hide()
	if is_3d_scene:
		$Background.show()

func _input(event):	
	if event.is_action_pressed("ui_cancel"):
		if visible:
			if is_3d_scene:
				$Background.show()
				await get_tree().process_frame
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Wwise.post_event("Pause_back", self)
			hide()
		else:
			Wwise.post_event("Pause", self)
			show()

func _on_exit_button_pressed() -> void:
	Wwise.post_event("UI_Choose", self)
	LevelManager.to_menu()

func _on_option_button_pressed() -> void:
	Wwise.post_event("UI_Choose", self)
	OptionsSettings.show()
	
func _on_hover_play_audio() -> void:
	Wwise.post_event("UI_Prechoose", self)
