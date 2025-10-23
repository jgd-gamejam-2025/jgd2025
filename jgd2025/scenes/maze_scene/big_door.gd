extends Node3D

@onready var gate_anim: AnimationPlayer = $AnimationPlayer

func open_gate1() -> void:
	gate_anim.play("open_gate1")
	
func open_gate2() -> void:
	gate_anim.play("open_gate2")
