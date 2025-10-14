extends MarginContainer

@onready var rich_text_label = $RichTextLabel

func resize():
	rich_text_label._on_resized()

func set_text(new_text: String):
	rich_text_label.text = new_text
	rich_text_label._on_resized()
