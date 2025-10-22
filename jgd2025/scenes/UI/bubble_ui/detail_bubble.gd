extends HBoxContainer

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var profile_pic = %ProfilePic
@onready var name_label = %Label

func set_text(text: String):
	rich_text_label.text = text
	rich_text_label._on_resized()

func set_bg_color(color: Color) -> void:
	# Get the current StyleBox from the RichTextLabel
	var style_box = rich_text_label.get_theme_stylebox("normal")
	
	# If it's a StyleBoxFlat, we can modify it directly
	if style_box is StyleBoxFlat:
		style_box.bg_color = color
		style_box.border_color = color
	else:
		# Create a new StyleBoxFlat if the current one isn't editable
		var new_style = StyleBoxFlat.new()
		new_style.bg_color = color
		new_style.border_width_left = 25
		new_style.border_width_top = 10
		new_style.border_width_right = 25
		new_style.border_width_bottom = 10
		new_style.border_color = color
		new_style.corner_radius_top_left = 35
		new_style.corner_radius_top_right = 35
		new_style.corner_radius_bottom_right = 35
		new_style.corner_radius_bottom_left = 35
		rich_text_label.add_theme_stylebox_override("normal", new_style)
