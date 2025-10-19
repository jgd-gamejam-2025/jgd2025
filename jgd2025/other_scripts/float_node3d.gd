extends Node3D

var float_time := 0.0  # accumulated time
var original_pos := position  # original position
@export var amplitude = 3.0

func _ready():
	original_pos = position

func _process(delta):
	# keep arrow floating up and down
	float_time += delta
	var offset = sin(float_time * 2.5) * amplitude  # frequency 2.0, amplitude 10 pixels
	position = original_pos + Vector3(0, offset, 0)


func set_target_position(pos: Vector3):
	original_pos = pos
