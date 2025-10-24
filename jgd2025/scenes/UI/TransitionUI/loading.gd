extends CanvasLayer

func display() -> void:
	# tween modulate alpha to 1
	var tween = create_tween()
	tween.tween_property($Control, "modulate:a", 0, 0)
	tween.tween_callback(self.show)
	tween.tween_property($Control, "modulate:a", 1, 0.5)

func disappear() -> void:
	# tween modulate alpha to 0
	var tween = create_tween()
	tween.tween_property($Control, "modulate:a", 0, 0.5)
	tween.tween_callback(self.hide)
