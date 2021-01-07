class_name Encounter
extends Node2D

onready var water_label = get_node("WaterLabel")

export var max_water := 10.0;
export var water_rate := 1.0;

var water: RollingInt;
var watering := false;

func _ready():
	water = RollingInt.new(max_water, 0, max_water);

func _process(delta):
	if (watering):
		water.change(-water_rate*delta);
		var plants: Array = get_tree().get_nodes_in_group('plant');
		var mouse_position := get_viewport().get_mouse_position();
		for plant in plants:
			if (mouse_position.distance_to(plant.position) <= 64.0):
				(plant as Plant).water.change(water_rate*delta)
	else:
		water.change(water_rate*delta*0.5)
	water_label.text = 'Vita: '+str(water.val)+'/'+str(max_water)

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			new_plant.energy_draw = 0.2;
			self.add_child(new_plant)
		return;
	if event.is_action_pressed("game_nourish"):
		watering = true
	if event.is_action_released("game_nourish"):
		watering = false
	if (event is InputEventMouseMotion):
		update()

func _draw():
	draw_circle(
		get_viewport().get_mouse_position(), 64.0, Color(0.0, 0.0, 1.0, 0.5)
	)
