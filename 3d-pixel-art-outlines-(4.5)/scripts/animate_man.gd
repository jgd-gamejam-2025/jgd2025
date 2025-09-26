extends Node3D
func _ready():
	var anim_player = $AnimationPlayer
	anim_player.play("Sprint")  
	anim_player.speed_scale = 1.0      
	anim_player.get_animation("Sprint").loop_mode = Animation.LOOP_LINEAR

func _process(delta):
	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized() * 5 * delta
		translate(input_vector)
	look_at(global_transform.origin + input_vector, Vector3.UP)
