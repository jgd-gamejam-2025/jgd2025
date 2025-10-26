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
			hide()
		else:
			show()

func _on_exit_button_pressed() -> void:
	LevelManager.to_menu()
