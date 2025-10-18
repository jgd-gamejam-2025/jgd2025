extends Node

@export var fps_interlude_scene: PackedScene
@export var fps_scene: PackedScene

func go_to_eve_debug_scene() -> void:
	Transition.set_bg_color(Color.BLACK)
	Transition.set_and_start("正在进入调试模式……", "")
	await get_tree().create_timer(2).timeout
	go_to_fps_interlude_scene()

func go_to_fps_interlude_scene() -> void:
	get_tree().change_scene_to_packed(fps_interlude_scene)

func go_to_fps_scene() -> void:
	get_tree().change_scene_to_packed(fps_scene)
