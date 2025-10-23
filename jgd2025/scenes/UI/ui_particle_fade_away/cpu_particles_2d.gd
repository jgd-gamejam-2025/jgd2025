extends CPUParticles2D


@export var move_down = true 
@export var left_most = 724 
@export var bottom_most = 58 
@export var x_speed = 30
@export var y_speed = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position.x <= left_most):
		var tween = create_tween() 
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
		set_process(false)
	if (move_down):
		position.y += y_speed
		if (position.y >= bottom_most):
			position.x -= x_speed
			move_down = false 
	else:
		position.y -= y_speed
		if (position.y <= 0):
			position.x += x_speed
			move_down = true 


func _on_color_rect_faded() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween() 
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	set_process(false) 
