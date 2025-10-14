extends RichTextLabel

@export var MAX_WIDTH: float = 715


func _ready() -> void:
	resized.connect(_on_resized)

func _on_resized() -> void:
	if size.x > MAX_WIDTH:
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		size.x = MAX_WIDTH
