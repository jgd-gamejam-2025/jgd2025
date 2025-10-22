extends Node3D

@onready var line = $Line3D

func _ready():
	line.points = [Vector3(0, 0, 0), Vector3(0, 0, -10)]
	line.width = 0.3
	line.material = StandardMaterial3D.new()
	line.material.emission_enabled = true
	line.material.emission = Color(0.2, 0.8, 1.0)
	line.material.emission_energy = 8.0
	line.material.unshaded = true
