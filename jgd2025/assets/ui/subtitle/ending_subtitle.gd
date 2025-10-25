extends Node2D


@onready var ending_subtitle = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ending_subtitle.play("ending_subtitle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
