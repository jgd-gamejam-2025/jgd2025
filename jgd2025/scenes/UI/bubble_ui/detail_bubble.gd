extends HBoxContainer

@onready var rich_text_label: RichTextLabel = %RichTextLabel

func set_text(text: String):
	rich_text_label.text = text
	rich_text_label._on_resized()
