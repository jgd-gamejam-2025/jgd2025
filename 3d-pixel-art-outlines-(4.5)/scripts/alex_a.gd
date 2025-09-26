extends Node3D
func _ready():
	var anim_player = $AnimationPlayer
	anim_player.play("Sprint")  
	anim_player.speed_scale = 1.0      
	anim_player.get_animation("Sprint").loop_mode = Animation.LOOP_LINEAR
