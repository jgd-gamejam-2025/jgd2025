extends Node3D

@onready var player = $Player
@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui
@onready var notification_box = $Notification

@onready var set_template = $RoomSet

var set_index = 0
var correct_choices = [1, 2, 3]

var curr_set

func _ready():
	pad.connect("pad_activated", _on_pad_pad_activated)
	pad.connect("pad_deactivated", _on_pad_pad_deactivated)
	Transition.end()
	chat_ui.set_bg_transparent()
	#set_template.hide()
	# generate_set(Vector3(0,0,0))
	#curr_set.set_question("Q1\n Answer is A", "A", "B", "C")
	#await get_tree().create_timer(4).timeout
	#curr_set.open_start_doors()
	#await get_tree().create_timer(12).timeout
	get_notification("嘿，你看到什么了？")


func generate_set(target_position: Vector3) -> void:
	curr_set = set_template.duplicate()
	add_child(curr_set)
	curr_set.show()
	curr_set.position = target_position
	curr_set.connect("choice_made", choice_made_handler)

func choice_made_handler(idx: int) -> void:
	await get_tree().create_timer(1.5).timeout
	curr_set.open_end_doors()
	var next_position = curr_set.get_next_set_global_position()
	curr_set.disconnect("choice_made", choice_made_handler)
	generate_set(next_position)
	if idx == correct_choices[set_index]:
		set_index += 1

	match set_index:
		0:
			curr_set.set_question("Q1\n 答案是 A", "A", "B", "C")
		1:
			curr_set.set_question("Q2\n 答案是 B", "A", "B", "C")
		2:
			curr_set.set_question("Q3\n 答案是 C", "A", "B", "C")
		_:
			#chat_ui.show_message("Congratulations! You've completed the test!")
			# level_complete()
			return	
	
	await get_tree().create_timer(1.5).timeout
	curr_set.open_start_doors()
	
func get_notification(message: String, duration: float = 3.0, name_text: String = "Eve"):
	chat_ui.to_chat_mode()
	chat_ui.add_and_write_detail_bubble(message, 0.02)
	notification_box.show_notification(message, duration, name_text)

func _input(event: InputEvent) -> void:
	# Detect USE_E input
	if event.is_action_pressed("use_e"):
		_on_use_e_pressed()
	
	# Detect USE_F input
	if event.is_action_pressed("use_f"):
		_on_use_f_pressed()
		
func rotate_door(door_node: Node3D, angle: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(door_node, "rotation_degrees:y", angle, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	return tween

# OPEN: door: y-, closet_ldoor: y+, closet_rdoor: y-

func _on_use_e_pressed() -> void:
	print("USE_E detected in room.gd")
	
func _on_use_f_pressed() -> void:
	print("USE_F detected in room.gd")

func _on_pad_pad_activated() -> void:
	notification_box.end_notification()

func _on_pad_pad_deactivated() -> void:
	pass


func _on_player_interact_obj(target: Node) -> void:
	if target.name == "Door2":
		rotate_door(target, -90)
