class_name PlantPhaseRes
extends Resource

export var texture: StreamTexture;

export var life_capacity := 10
export var water_capacity := 5
export var water_draw := 1.0
export var energy_draw := 1.0
export var energy_draw_range := 50
export var growth_rate := 1.0

func _property_to_string(property: String):
	return '['+property+': '+str(get(property))+']';

func _to_string():
	return prints(
		_property_to_string('life_capacity'),
		_property_to_string('water_capacity'),
		_property_to_string('water_draw'),
		_property_to_string('energy_draw'),
		_property_to_string('energy_draw_range'),
		_property_to_string('growth_rate')
	)
