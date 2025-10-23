extends ColorRect

@export var shrink_speed_px_per_frame: float = 0.02
@export var min_width: float = 0.0 
@export var bubble_left_edge = 724

signal faded


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (size.x <= bubble_left_edge):
		faded.emit() 
	if size.x <= min_width: 
		size = Vector2(min_width, size.y)
		set_process(false)
		return    
	var new_width := int(max(min_width, size.x - shrink_speed_px_per_frame))
	size = Vector2(new_width, size.y)
