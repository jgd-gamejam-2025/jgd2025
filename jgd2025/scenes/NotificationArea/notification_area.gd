extends Area3D

@export var text = ""
@export var one_time = true

signal area_text(message: String)

func _ready():
	# scan for all collisionshape and connect body entered signal
	for shape in get_children():
		if shape is CollisionShape3D:
			shape.connect("body_entered", Callable(self, "_on_body_entered"))
		

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		area_text.emit(text)
		if one_time:
			queue_free()
