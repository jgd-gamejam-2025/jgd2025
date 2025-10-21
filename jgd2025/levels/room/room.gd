extends Node3D

@onready var player = $Player
@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui
@onready var notification_box = $Notification
const far_away_position = Vector3(0, -1000, 0)

@onready var room1 = $RoomSet
@onready var room2 = $RoomSet2
@onready var room3 = $RoomSet3
@onready var room4 = $RoomSet4

var curr_room = 1
var curr_pass = false

func _ready():
	pad.connect("pad_activated", _on_pad_pad_activated)
	pad.connect("pad_deactivated", _on_pad_pad_deactivated)
	# room1 & room2 are ready
	put_away(room3)
	put_away(room4)
	# put_away($TrueDoor21)
	# put_away($TrueDoor22)
	put_away($TrueDoor3)
	Transition.end()
	chat_ui.set_bg_transparent()
	get_notification("嘿，你看到什么了？")

	
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
	next_step()

func _on_pad_pad_activated() -> void:
	notification_box.end_notification()

func _on_pad_pad_deactivated() -> void:
	pass

func _on_player_interact_obj(target: Node) -> void:
	if target.name == "Door2":
		rotate_door(target, -90)
	if target.name == "Monitor":
		print("Interacted with Monitor")

func next_step() -> void:
	match curr_room:
		1:
			if not curr_pass:
				rotate_door($TrueDoor1, 90)
				curr_pass = true
			else:
				await rotate_door($TrueDoor1, 180).finished
				await get_tree().process_frame
				put_away(room1)
				load_node(room3)
				load_node($TrueDoor3)
				curr_room = 2
				curr_pass = false
		2:
			if not curr_pass:
				rotate_door($TrueDoor21, 50)
				rotate_door($TrueDoor22, 90)
				curr_pass = true
			else:
				await rotate_door($TrueDoor21, 180).finished
				await rotate_door($TrueDoor22, 0).finished
				await get_tree().process_frame
				put_away($TrueDoor1)
				put_away(room2)
				load_node(room4)
				curr_room = 3
				curr_pass = false
		3:
			if not curr_pass:
				rotate_door($TrueDoor3, 110)
				curr_pass = true
			else:
				await rotate_door($TrueDoor3, 0).finished
				await get_tree().process_frame
				put_away(room3)
				curr_room = 4
				curr_pass = false

func put_away(room_set: Node3D) -> void:
	room_set.position += far_away_position
	room_set.hide()
	# for child in room_set.find_children("*", "CollisionShape3D"):
	# 	child.disabled = true

func load_node(room_set: Node3D) -> void:
	room_set.position -= far_away_position
	room_set.show()
	# for child in room_set.find_children("*", "CollisionShape3D"):
	# 	child.disabled = false
