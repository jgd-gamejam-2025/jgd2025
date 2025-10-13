extends RichTextLabel


const MAX_WIDTH: float = 1200.0


func _ready() -> void:
	resized.connect(_on_resized)
	$Timer.timeout.connect(_type_letter)
	text = ""


func _type_letter() -> void:
	text += "好我今天吃饭了吃了很多很多。"
	text += " " if randf() > 0.7 else ""


func _on_resized() -> void:
	if size.x > MAX_WIDTH:
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		size.x = MAX_WIDTH
