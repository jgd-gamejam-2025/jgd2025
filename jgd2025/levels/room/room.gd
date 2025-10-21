extends Node3D

@onready var player = $Player
@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui
@onready var notification_box = $Notification
const far_away_position = Vector3(0, -1000, 0)
@onready var blow_point: Marker3D = $BlownTo

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
	put_away($TrueDoor23)
	put_away($TrueDoor24)
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
	var wobble_level = 99
	var tween = create_tween()
	tween.tween_callback(func():
		blow_away(room1.get_node("sm_ceiling"), 4, false)
	)
	tween.tween_interval(0.2)
	tween.tween_callback(func():
		blow_away(room1.get_node("sm_right_wall"), 4, false)
	)
	tween.tween_interval(0.2)
	tween.tween_callback(func():
		blow_away($TrueDoor22, 5, true, wobble_level)
	)
	tween.tween_interval(0.2)
	tween.tween_callback(func():
		blow_away(room1.get_node("sm_front_wall2"), 5, true, 77)
	)
	tween.tween_interval(0.5)
	await tween.finished
	tween = create_tween()
	var tween2 = create_tween()
	var all_blow_nodes = get_tree().get_nodes_in_group("blow")
	for node in all_blow_nodes:
		if node.visible == false:
			continue
		print("Blowing away: %s" % node.name)
		tween.tween_callback(func():
			blow_away(node, 3, true, wobble_level)
		)
		tween.tween_interval(0.3)
	# tween.tween_callback(func():
	# 	blow_away(room1.get_node("Desk"), 2, true, wobble_level)
	# )
	# tween.tween_interval(0.5)
	# tween.tween_callback(func():
	# 	blow_away(room1.get_node("sm_office_chair"), 2, true, wobble_level)
	# )
	# tween.tween_interval(0.5)
	# tween.tween_callback(func():
	# 	blow_away(room1.get_node("sm_photo5"), 2, true, wobble_level)
	# )
	# tween.tween_interval(0.5)
	# tween.tween_callback(func():
	# 	blow_away(room1.get_node("sm_photo3"), 2, true, wobble_level)
	# )
	# tween.tween_interval(0.5)
	# tween.tween_callback(func():
	# 	blow_away(room1.get_node("sm_photo4"), 2, true, wobble_level)
	# )
	tween2.tween_interval(2.5)
	tween2.tween_callback(func():
		pad.move_when_angle = 30
		pad.move_until_angle = 0
	)
	tween2.tween_interval(1)
	tween2.tween_callback(func():
		pad.follow_player = false
		blow_away(pad, 5, true, wobble_level)
	)
	tween2.tween_interval(1)
	tween2.tween_callback(func():
		blow_away(player, 5, true, wobble_level)
	)
	# next_step()

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
				load_node($TrueDoor23)
				load_node($TrueDoor24)
				load_node($TrueDoor3)
				curr_room = 2
				curr_pass = false
		2:
			if not curr_pass:
				var temp_tween = create_tween()
				temp_tween.set_parallel()
				temp_tween.tween_property($TrueDoor21, "rotation_degrees:y", 50, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor22, "rotation_degrees:y", 90, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor23, "rotation_degrees:y", -100, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor24, "rotation_degrees:y", 120, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				curr_pass = true
			else:
				var temp_tween = create_tween()
				temp_tween.set_parallel()
				temp_tween.tween_property($TrueDoor21, "rotation_degrees:y", 180, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor22, "rotation_degrees:y", 0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor23, "rotation_degrees:y", 0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				temp_tween.tween_property($TrueDoor24, "rotation_degrees:y", 0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				await temp_tween.finished
				put_away($TrueDoor1)
				put_away($TrueDoor21)
				put_away($TrueDoor22)
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

func blow_away(node: Node3D, duration: float = 2.0, tumble: bool = true, tumble_strength: float = 720.0) -> Tween:
	# effect: blow an object away but not using physics
	# The object should be blown away like a super strong wind is pushing it to the blow_point
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Calculate the target position
	var end_pos = blow_point.global_position
	
	# Move with easing to simulate wind acceleration and deceleration
	tween.tween_property(node, "global_position", end_pos, duration)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# Add tumbling rotation if enabled (simulates wind making it spin)
	if tumble:
		var random_rotation = Vector3(
			randf_range(-tumble_strength, tumble_strength),
			randf_range(-tumble_strength, tumble_strength),
			randf_range(-tumble_strength, tumble_strength)
		)
		tween.tween_property(node, "rotation_degrees", node.rotation_degrees + random_rotation, duration)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
	
	# Optional: Add wobble during movement by modulating the main tween
	var wobble_tween = create_tween()
	wobble_tween.set_loops(int(duration * 10))
	wobble_tween.tween_callback(func():
		var wobble_offset = Vector3(
			randf_range(-0.3, 0.3),
			randf_range(-0.2, 0.2),
			randf_range(-0.3, 0.3)
		)
		node.position += wobble_offset
	).set_delay(0.05)
	
	return tween
	
