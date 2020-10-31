class_name SpecterResource
extends Resource

export var max_life_force: int;
export var idle_life_force: int;
export var sprite: StreamTexture;
export var abilities: Array;

func init_abilities() -> void:
	var ability_resources := []
	for ability in abilities:
		var resource = load('res://data/abilities/'+ability+'.tres')
		ability_resources.push_back(resource)
	abilities = ability_resources
