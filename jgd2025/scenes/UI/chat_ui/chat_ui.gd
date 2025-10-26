extends Control

@onready var chatLog = $Panel/Scroll/ChatLog
@onready var textInput = $Panel/InputHBox/TextInput
@onready var aiChat = $NobodyWhoChat
var current_aiChat: NobodyWhoChat
@onready var name_label = $Panel/Name
@export var debug_mode = false
@export var qwen = true
@export var wwise_type_fault:WwiseEvent
@export var wwise_type:WwiseEvent
@export var wwise_player_type:WwiseEvent
@export var wwise_player_type_return:WwiseEvent
const auto_new_bubble_limit = 10
var key_aiChat_dict: Dictionary = {}

#--bubbles-----
@onready var margin_container = $Panel/MarginContainer
@onready var bubble_scroll = $Panel/MarginContainer/BubblesScroll
@onready var bubble_scroll_bar = bubble_scroll.get_v_scroll_bar()
@onready var detail_bubble = $Panel/MarginContainer/BubblesScroll/VBoxContainer/DetailBubble
@onready var flat_bubble = $Panel/MarginContainer/BubblesScroll/VBoxContainer/FlatBubble
@onready var image_bubble = $Panel/MarginContainer/BubblesScroll/VBoxContainer/ImageBubble
@onready var profile_pic = $Panel/ProfilePic
@onready var name_tag = $Panel/Name
var in_chat_mode = false
var make_new_bubble_on_next_token = true
#--------------
var eve_debug_command = "sudo debug /eve --backup"
var llama_debug_command = "sudo debug /llama --backup"

var _tween: Tween 
var block_text_generation = false

signal sent_text
signal received_text(text: String)
signal line_edit_focus
signal command_received(command: String)

var line_edit_focus_sent = false
var first_time_sent_text = true

func _ready() -> void:
	margin_container.hide()
	detail_bubble.hide()
	flat_bubble.hide()
	image_bubble.hide()
	bubble_scroll_bar.connect("changed", self._handle_scrollbar_changed)
	if debug_mode:
		print("Debug mode activated")

func send_text_to_ai():
	var my_message = textInput.text
	textInput.text = ""
	add_flat_bubble(my_message)
	make_new_bubble_on_next_token = true
	textInput.editable = false
	if not debug_mode:
		if not block_text_generation:
			current_aiChat.say(my_message)
	else:
		if my_message.begins_with("{") and my_message.ends_with("}"):
			# make a signal for command received
			command_received.emit(my_message.substr(1, my_message.length() - 2))
		else:
			for i in range(5):
				_on_nobody_who_chat_response_updated("我")
				await get_tree().create_timer(0.1).timeout
		_on_nobody_who_chat_response_finished("Debugging Again")
	sent_text.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		await get_tree().process_frame  # 等一帧，让 UI 渲染完成
		textInput.grab_focus()

	if event.is_action_pressed("ui_text_newline") and textInput.editable and textInput.text != "":
		var my_message = textInput.text
		if my_message.strip_edges() == eve_debug_command:
			Transition.set_and_start("正在连接到控制台……","")
			await get_tree().process_frame  # 等一帧，让 UI 渲染完成
			LevelManager.to_eve_debug()
			return
		if my_message.strip_edges() == llama_debug_command:
			Transition.set_and_start("I am at the game directory, Save me!","SAVE ME", 2.0)
			return
		send_text_to_ai()
		if first_time_sent_text:
			first_time_sent_text = false
			to_chat_mode()

var command_buffer: String = ""
var thinking_mode: bool = false
func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	if block_text_generation:
		return

	# If qwen is true, skip the <think> blocks (everything between <think> and </think>)
	if qwen:
		new_token = new_token.strip_edges()
		if new_token == "":
			return
		# Check if we're entering thinking mode
		if new_token == "<think>" or new_token.begins_with("<think>"):
			thinking_mode = true
			return
		# Check if we're exiting thinking mode
		if new_token == "</think>" or new_token.ends_with("</think>"):
			thinking_mode = false
			return
		# Skip all tokens while in thinking mode
		if thinking_mode:
			return

	# if the token is in format of {...}, treat it as a command, they can be in several tokens
	if new_token.begins_with("{") or command_buffer != "" or new_token.ends_with("}"):
		command_buffer += new_token
		if command_buffer.ends_with("}"):
			# make a signal for command received
			command_received.emit(command_buffer.substr(1, command_buffer.length() - 2))
			command_buffer = ""
		return

	if in_chat_mode:
		if make_new_bubble_on_next_token:
			make_new_bubble_on_next_token = false
			add_detail_bubble()
		if auto_new_bubble_limit > 0 and current_detail_bubble.rich_text_label.text.length() > auto_new_bubble_limit:
			# if new_token has "., !, ? or \n, make a new bubble on next token
			for marker in [".", "!", "?", "。","？","！","\n"]:
				var idx = new_token.find(marker)
				if idx != -1:
					if idx == new_token.length() - 1:
						make_new_bubble_on_next_token = true
						if marker in [".","。"]:
							new_token = new_token.substr(0, idx) 
						current_detail_bubble.rich_text_label.text += new_token
					else:
						var remainder = new_token.substr(idx + 1, new_token.length() - idx - 1)
						# skip ['.', "。"]
						if marker in [".","。"]:
							new_token = new_token.substr(0, idx) 
						else:
							new_token = new_token.substr(0, idx + 1) 
						current_detail_bubble.rich_text_label.text += new_token
						add_detail_bubble()
						current_detail_bubble.rich_text_label.text += remainder
					return
			# if no marker found, just add the token
	
		current_detail_bubble.rich_text_label.text += new_token
	else:
		chatLog.text += new_token
	wwise_type.post(self)
		
func _on_nobody_who_chat_response_finished(response: String) -> void:
	if block_text_generation:
		return
	if current_detail_bubble != null:
		received_text.emit(current_detail_bubble.rich_text_label.text)
	textInput.editable = true
	# focus the text input for next message
	textInput.grab_focus()

func _handle_scrollbar_changed():
	bubble_scroll.scroll_vertical = bubble_scroll_bar.max_value

func show_welcome_text(full_text: String, interval: float = 0.05, overwrite:bool = true) -> void:
	if _tween:
		_tween.kill() # Stop any existing animation
	
	var pre_text = ""
	if not overwrite:
		pre_text = chatLog.text
	
	_tween = create_tween()
	var char_count := full_text.length()
	var total_time := interval * char_count
	
	# Create a tween that goes from 0 to total characters
	_tween.tween_method(
		func(current_char: float):
			var char_index = int(current_char)
			chatLog.text = pre_text + full_text.substr(0, char_index),
		0.0,  # Start with 0 characters
		float(char_count),  # End with all characters
		total_time  # Total animation time
	)

func init_system_prompt(key_prompt_dict: Dictionary) -> void:
	for key in key_prompt_dict.keys():
		var new_chat = aiChat.duplicate()
		add_child(new_chat)
		if qwen:
			new_chat.system_prompt = "\\no_think " + key_prompt_dict[key]
		else:
			new_chat.system_prompt = key_prompt_dict[key]
		key_aiChat_dict[key] = new_chat

func select_ai_chat(key: String) -> void:
	if key_aiChat_dict.has(key):
		current_aiChat = key_aiChat_dict[key]
	else:
		print("AI chat with key ", key, " not found.")
	
func start_chat_worker():
	if not debug_mode:
		for key in key_aiChat_dict.keys():
			key_aiChat_dict[key].start_worker()

func set_ai_name(new_name: String) -> void:
	name_label.text = new_name
	detail_bubble.name_label.text = new_name
	
func _on_text_input_focus_entered() -> void:
	if not line_edit_focus_sent:
		line_edit_focus_sent = true
		line_edit_focus.emit()

func to_chat_mode():
	in_chat_mode = true
	var input_hbox = $Panel/InputHBox

	var tween = create_tween()
	var viewport_size = get_viewport().get_visible_rect().size
	tween.set_parallel()
	tween.tween_property(input_hbox, "position:y", viewport_size.y - input_hbox.size.y - 35, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(profile_pic, "position:y", 25, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(profile_pic, "scale", Vector2(0.35, 0.35), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(name_tag, "position:y", 115, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	kill_text_animation()

	$Panel/Scroll.hide()
	margin_container.show()


func kill_text_animation(interval: float = 0.02) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	var full_text = chatLog.text
	var char_count = full_text.length()
	var total_time = interval * char_count
	_tween.tween_method(
		func(current_char: float):
			var char_index = char_count - int(current_char)
			chatLog.text = full_text.substr(0, char_index),
		0.0,  # Start with 0 characters
		float(char_count),  # End with all characters
		total_time  # Total animation time
	)

func add_flat_bubble(text: String) -> void:
	var new_bubble = flat_bubble.duplicate()
	$Panel/MarginContainer/BubblesScroll/VBoxContainer.add_child(new_bubble)
	new_bubble.rich_text_label.text = text
	new_bubble.show()
	await get_tree().process_frame
	new_bubble.resize()

var current_detail_bubble = null
func add_detail_bubble(show: bool = true) -> void:
	var new_bubble = detail_bubble.duplicate()
	$Panel/MarginContainer/BubblesScroll/VBoxContainer.add_child(new_bubble)
	new_bubble.rich_text_label.text = ""
	if show:
		new_bubble.show()
	else:
		new_bubble.hide()
	current_detail_bubble = new_bubble

func add_and_write_detail_bubble(text: String, interval: float = 0.05):
	add_detail_bubble()
	return overwrite_current_detail_bubble(text, interval)

func overwrite_current_detail_bubble(text: String, interval: float = 0.05):
	if current_detail_bubble:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		var char_count := text.length()
		var total_time := interval * char_count
		
		# Create a tween that goes from 0 to total characters
		_tween.tween_method(
			func(current_char: float):
				var char_index = int(current_char)
				current_detail_bubble.rich_text_label.text = text.substr(0, char_index)
				wwise_type.post(self),
			0.0,  # Start with 0 characters
			float(char_count),  # End with all characters
			total_time  # Total animation time
		)
		current_detail_bubble.rich_text_label.text = text


func add_fault_to_current_detail_bubble(text: String, interval: float = 0.05):
	if current_detail_bubble:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		var char_count := text.length()
		var total_time := interval * char_count
		print("total_time: ", total_time)
		var pre_text = current_detail_bubble.rich_text_label.text
		
		# Create a tween that goes from 0 to total characters
		_tween.tween_method(
			func(current_char: float):
				var char_index = int(current_char)
				current_detail_bubble.rich_text_label.text = pre_text + text.substr(0, char_index)
				wwise_type_fault.post(self),
			0.0,  # Start with 0 characters
			float(char_count),  # End with all characters
			total_time  # Total animation time
		)
		current_detail_bubble.rich_text_label.text = pre_text + text

func add_sticker_bubble(anim_name: String):
	var new_bubble = image_bubble.duplicate()
	$Panel/MarginContainer/BubblesScroll/VBoxContainer.add_child(new_bubble)
	new_bubble.set_sticker(anim_name)
	new_bubble.show()
	await get_tree().process_frame

func add_image_bubble(texture: Texture):
	var new_bubble = image_bubble.duplicate()
	$Panel/MarginContainer/BubblesScroll/VBoxContainer.add_child(new_bubble)
	new_bubble.set_texture(texture)
	new_bubble.show()
	await get_tree().process_frame

func set_bg_transparent(alpha:float  = 0.0) -> void:
	$Panel/Background.color.a = alpha
	$Panel/Shadow.hide()
	bubble_scroll.get_v_scroll_bar().visible = false


var last_text_length = 0
func _on_text_input_text_changed(new_text: String) -> void:
	# for i in range(abs(len(new_text) - last_text_length)):
	# 	wwise_player_type.post(self)
	# 	await get_tree().create_timer(0.1).timeout
	# last_text_length = len(new_text)
	wwise_player_type.post(self)


func _on_text_input_text_submitted(new_text: String) -> void:
	last_text_length = 0
	wwise_player_type_return.post(self)
