extends CanvasLayer

signal yes
signal unsure
signal no

func _on_yes_pressed() -> void:
	yes.emit()


func _on_unsure_pressed() -> void:
	unsure.emit()


func _on_no_pressed() -> void:
	no.emit()

func set_title(text: String):
	%Title.text = text
	
func set_content(text: String):
	%Content.text = text
