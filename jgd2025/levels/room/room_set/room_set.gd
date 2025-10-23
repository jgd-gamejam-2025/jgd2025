extends Node3D

@onready var lamb_light = $OmniLight3D
@onready var back_light = $SpotLight3D
@onready var ambient_light = $OmniLight3D_Ambient

var lamb_light_energy
var back_light_energy
var ambient_light_energy

func _ready():
	lamb_light_energy = lamb_light.light_energy
	back_light_energy = back_light.light_energy
	ambient_light_energy = ambient_light.light_energy

func light_on():
	# light generally light up the set up energy
	var tween = create_tween()
	tween.tween_property(lamb_light, "light_energy", lamb_light_energy, 1.0)
	tween.tween_property(back_light, "light_energy", back_light_energy, 1.0)
	tween.tween_property(ambient_light, "light_energy", ambient_light_energy, 1.0)

func light_off():
	var tween = create_tween()
	tween.tween_property(lamb_light, "light_energy", 0, 1.0)
	tween.tween_property(back_light, "light_energy", 0, 1.0)
	tween.tween_property(ambient_light, "light_energy", 0, 1.0)
