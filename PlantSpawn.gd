extends Node2D

export var initial_level := 0;
export var initial_life := 0;
export var initial_water := 0;

export var plant_spec: Resource setget _set_spec;
func _set_spec(new_spec):
	if !(new_spec is PlantRes):
		push_error('PlantSpawn resource must be PlantRes, received '+to_json(new_spec))
	else:
		plant_spec = new_spec;

func _ready():
	var status = get_parent().connect("ready", self, 'create_plant');
	if status != OK: push_error('Failed to hook up plant spawn to parent ready: '+status)

func create_plant():
	var new_plant = Plant.create(plant_spec, initial_level, initial_life, initial_water);
	new_plant.position = self.position;
	get_parent().add_child_below_node(self, new_plant)
	self.queue_free()
