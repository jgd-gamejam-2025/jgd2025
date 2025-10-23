extends Label3D
var typing_speed: float = 0.1
var full_text: String = ""
var current_index: float = 0.0  # Changed to float
var is_showing: bool = false
var is_hiding: bool = false

func _ready():
	full_text = text
	text = ""

func _process(delta):
	if is_showing and current_index < full_text.length():
		current_index += typing_speed * 100 * delta
		text = full_text.substr(0, int(current_index))
		
		if current_index >= full_text.length():
			is_showing = false
	elif is_hiding and current_index > 0:
		# Deleting text backwards
		current_index -= typing_speed * 100 * delta
		text = full_text.substr(0, max(0, int(current_index)))
		
		if current_index <= 0:
			is_hiding = false
			text = ""

func show_effect():
	current_index = 0.0  # Changed to 0.0
	text = ""  # Reset text to empty when starting to show
	is_showing = true
	is_hiding = false

func hide_effect():
	current_index = full_text.length()
	text = full_text  # Set text to full when starting to delete
	is_showing = false
	is_hiding = true
