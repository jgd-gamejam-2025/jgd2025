extends CanvasLayer

@export var user_name: String = "user"
@export var host_name: String = "terminal"
@export var default_type_speed: float = 0.03  # Seconds per character
@export var type_speed_variance: float = 0.02  # Random variance in typing speed
@export var wwise_type :WwiseEvent

@onready var output_area: RichTextLabel = $MarginContainer/Panel/VBoxContainer/OutputArea
@onready var input_field: LineEdit = $MarginContainer/Panel/VBoxContainer/InputArea/LineEdit
@onready var prompt_label: Label = $MarginContainer/Panel/VBoxContainer/InputArea/Prompt
@onready var special_label: RichTextLabel = $SubViewportContainer/SubViewport/SpecialLabel
@onready var special_label2: RichTextLabel = $SubViewportContainer/SubViewport/SpecialLabel2
@onready var special_label3: RichTextLabel = $SubViewportContainer/SubViewport/SpecialLabel3
@onready var special_label4: RichTextLabel = $SubViewportContainer/SubViewport/SpecialLabel4
@onready var special_label5: RichTextLabel = $SubViewportContainer/SubViewport/SpecialLabel5
@onready var special_white: ColorRect = $CenterContainer/White

var _tween: Tween
var _current_text: String = ""
var _is_typing := false
var _input_blocked := false

signal input_submitted(command: String)

func is_input_blocked() -> bool:
	return _input_blocked

func _ready() -> void:
	# Set up the prompt with username
	update_prompt()
	# Connect to the input field's text entered signal
	input_field.text_submitted.connect(_on_input_submitted)
	# Give focus to input field automatically
	input_field.grab_focus()
	
	# Welcome message
	#write_line("Terminal v1.0 initialized.\nType your commands below.")

func _input(event: InputEvent) -> void:
	if _input_blocked:
		return
		
	if event.is_action_pressed("ui_cancel"):  # ESC key
		input_field.release_focus()
	elif event is InputEventKey and !input_field.has_focus():
		input_field.grab_focus()  # Regain focus when typing

func block_input() -> void:
	_input_blocked = true
	input_field.editable = false
	input_field.release_focus()

func enable_input() -> void:
	_input_blocked = false
	input_field.editable = true
	input_field.grab_focus()

func expand_ascii_art(ascii_text: String, scale: int = 2) -> String:
	var lines = ascii_text.split("\n")
	var result = []
	
	# For each line in the original ASCII art
	for line in lines:
		var scaled_lines = []
		# Initialize 'scale' number of empty strings for this line
		for i in range(scale):
			scaled_lines.append("")
		
		# For each character in the line
		for char in line:
			# If it's an X, add a scaled block
			if char == "X":
				for i in range(scale):
					scaled_lines[i] += "X".repeat(scale)
			# If it's a space, add scaled spaces
			else:
				for i in range(scale):
					scaled_lines[i] += " ".repeat(scale)
		
		# Add all scaled lines to the result
		result.append_array(scaled_lines)
	
	# Join all lines with newlines
	var result_text = "\n".join(result)
	#strip leading/trailing newlines \n
	while result_text.begins_with("\n"):
		result_text = result_text.substr(1)
	return result_text

func update_prompt() -> void:
	prompt_label.text = "%s@%s>" % [get_system_user_name(), host_name]
	# prompt_label.text = "%s@%s>" % [user_name, host_name]
	

func write_line_static(text: String) -> void:
	output_area.text += text
	wwise_type.post(self)
	# output_area.scroll_to_line(output_area.get_line_count() - 1)

func write_line(text: String, type_speed: float = default_type_speed) -> Tween:
	if _is_typing:
		if _tween:
			_tween.kill()
	_is_typing = true
	var start_pos = output_area.text.length()
	_current_text = output_area.text + text + "\n"
	
	_tween = create_tween()
	var total_chars = text.length() + 1  # +1 for newline
	var type_sound_interval = 3
	if type_speed < 0.03:
		type_sound_interval = 9
	for i in range(total_chars):
		var char_delay = type_speed + randf_range(-type_speed_variance, type_speed_variance)
		_tween.tween_callback(func():
			output_area.text = _current_text.substr(0, start_pos + i + 1)
			if (i % type_sound_interval) == 0:  # Post based on type speed
				wwise_type.post(self)
		).set_delay(char_delay)
	
	_tween.tween_callback(func(): _is_typing = false)
	return _tween

func _on_input_submitted(text: String) -> void:
	# Echo the command with full prompt
	var pre_text = "[color=#03f0fc]%s@%s>[/color] %s\n" % [user_name, host_name, text]
	write_line_static(pre_text)
	
	# Clear the input field
	input_field.clear()
	
	# Process the command here
	match text.strip_edges().to_lower():
		"help":
			write_line("Available commands: whoami, hostname, help")
		"whoami":
			write_line(user_name)
		"hostname":
			write_line(host_name)
		_:
			input_submitted.emit(text)

func write_lines_sync(text: String, output_area: RichTextLabel = output_area) -> Tween:
	if _is_typing:
		if _tween:
			_tween.kill()
	
	_is_typing = true
	var start_pos = output_area.text.length()
	var lines = text.split("\n")
	_current_text = output_area.text + text + "\n"
	
	# Find the longest line length
	var max_length = 0
	for line in lines:
		max_length = max(max_length, line.length())
	
	_tween = create_tween()
	
	# For each character position
	for pos in range(max_length + 1):  # +1 for final newlines
		_tween.tween_callback(func():
			var temp_text = output_area.text.substr(0, start_pos)
			# Update each line up to current position
			for i in range(lines.size()):
				var line = lines[i]
				var adjusted_pos = pos
				temp_text += line.substr(0, min(adjusted_pos, line.length()))
				temp_text += "\n"  # Add newline for each line
			output_area.text = temp_text
		).set_delay(default_type_speed)
	
	# Final callback to mark typing as complete
	_tween.tween_callback(func():
		_is_typing = false
		output_area.text = _current_text
	)
	return _tween

func write_art_sync(text: String, output_area: RichTextLabel = output_area, keep_flipping_time: float = 10.0, skip_generate: bool = false, speed: float = default_type_speed) -> Tween:
	var write_art_tween = create_tween()
	
	_is_typing = true
	var start_pos = output_area.text.length()
	var lines = text.split("\n")
	_current_text = output_area.text + text + "\n"
	
	# Store the original pattern for final display
	var original_lines = lines.duplicate()
	
	# Characters to use for random replacement
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var chars_length = chars.length()
	
	# Find the longest line length
	var max_length = 0
	for line in lines:
		max_length = max(max_length, line.length())
	
	
	if not skip_generate:
		# For each character position
		for pos in range(max_length + 1):  # +1 for final newlines
			write_art_tween.tween_callback(func():
				var temp_text = output_area.text.substr(0, start_pos)
				# Update each line up to current position
				for i in range(lines.size()):
					var line = original_lines[i]
					var current_line = ""
					# Process each character up to current position
					for j in range(min(pos, line.length())):
						if line[j] != " ":
							# Get a random character
							current_line += chars[randi() % chars_length]
						else:
							current_line += line[j]  # Space or any other character
					temp_text += current_line + "\n"
				output_area.text = temp_text
			).set_delay(speed)
	else:
		# If skipping generation, immediately show the full pattern with random characters
		write_art_tween.tween_callback(func():
			var temp_text = output_area.text.substr(0, start_pos)
			for line in original_lines:
				var current_line = ""
				for char in line:
					if char != " ":
						current_line += chars[randi() % chars_length]
					else:
						current_line += char
				temp_text += current_line + "\n"
			output_area.text = temp_text
		)
	
	# If keep_flipping_time > 0, continue flipping characters
	if keep_flipping_time > 0:
		var flip_steps = int(keep_flipping_time / default_type_speed)
		for i in range(flip_steps):
			write_art_tween.tween_callback(func():
				var temp_text = output_area.text.substr(0, start_pos)
				for line in original_lines:
					var current_line = ""
					for char in line:
						if char != " ":
							current_line += chars[randi() % chars_length]
						else:
							current_line += char
					temp_text += current_line + "\n"
				output_area.text = temp_text
			).set_delay(default_type_speed)
	
	# Final callback to mark typing as complete
	write_art_tween.tween_callback(func():
		_is_typing = false
		# Generate final random state
		var final_text = output_area.text.substr(0, start_pos)
		for line in original_lines:
			var final_line = ""
			for char in line:
				if char != " ":
					final_line += chars[randi() % chars_length]
				else:
					final_line += char
			final_text += final_line + "\n"
		output_area.text = final_text
	)
	return write_art_tween

func get_system_user_name() -> String:
	var name := OS.get_environment("USERNAME") # Windows
	if name.is_empty():
		name = OS.get_environment("USER") # macOS / Linux
	return name
