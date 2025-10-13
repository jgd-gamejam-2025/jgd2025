extends Node3D

@export var next_scene : PackedScene

func _ready():
	Transition.end()

func _on_area_3d_body_entered(body: Node3D) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Transition.set_and_start("正在尝试重新连接……", "")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(next_scene)
