extends Node

@onready var chat_ui = $ChatUI

func _ready():
	chat_ui.show_text_gradually("嘿！问你话呢，晚上想吃什么？")
