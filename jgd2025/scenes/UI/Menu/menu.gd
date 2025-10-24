extends CanvasLayer

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect/Image, "modulate:a", 1, 1.0)

	if not LevelManager.has_save():
		$ColorRect/MarginContainer/VBoxContainer/Continue.hide()
		

func _on_continue_pressed() -> void:
	LevelManager.load_game()


func _on_new_game_pressed() -> void:
	LevelManager.to_chat_1()


func _on_exit_pressed() -> void:
	get_tree().quit()
