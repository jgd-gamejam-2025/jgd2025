extends Node

@export var eve_debug_scene: PackedScene

func to_eve_debug():
	print("Cheat code activated: Transitioning to Eve Debug Scene")
	get_tree().change_scene_to_packed(eve_debug_scene)
