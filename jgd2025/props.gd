extends CanvasLayer
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("use_e"): 
		hide()

func set_prop(name):
	for child in get_children():
		if child.name == name or child.name == "Background" or child.name == "Label":
			child.show()
		else:
			child.hide()
