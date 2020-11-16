class_name Storm
extends Node2D

const energy_delta_rate := -0.2

export var energy := 100

onready var energy_label := get_node("Label");

var energy_remainder := 0.0

func _process(delta):
	energy_remainder += energy_delta_rate*delta
	if (energy_remainder < 1.0):
		var energy_delta = ceil(energy_remainder)
		energy += energy_delta
		energy_remainder -= energy_delta
		energy_label.text = 'ENERGY: '+str(energy)
