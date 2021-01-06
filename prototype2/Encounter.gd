class_name Encounter
extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			new_plant.energy_draw = 0.2;
			self.add_child(new_plant)
	if event.is_action_pressed("game_nourish"):
		var plants: Array = get_tree().get_nodes_in_group('plant');
		for plant in plants:
			(plant as Plant).water.change(3.0)
