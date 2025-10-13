extends Node2D

# Define the next scene to load in the inspector
@export var next_level : PackedScene

func _ready():
	Transition.end()

func _on_level_finish_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_group("Player", "death_tween") # death_tween is called here just to give the feeling of player entering the door.
		AudioManager2D.level_complete_sfx.play()
		# 2d platformer template 自帶的transition， 这里换成了我们自己的transition
		# SceneTransition2D.load_scene(next_level)
		Transition.set_and_start("边缘","")
		await get_tree().create_timer(0.7).timeout
		get_tree().change_scene_to_packed(next_level)
		
