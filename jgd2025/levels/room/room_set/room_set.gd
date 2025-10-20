extends Node3D

@onready var door = $Door
@onready var closet_ldoor = $LClosetDoor
@onready var closet_rdoor = $RClosetDoor


func rotate_door(door_node: Node3D, angle: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(door_node, "rotation_degrees:y", angle, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	return tween

# OPEN: door: y-, closet_ldoor: y+, closet_rdoor: y-
