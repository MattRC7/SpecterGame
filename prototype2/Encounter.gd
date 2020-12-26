class_name Encounter
extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		var plants = get_tree().get_nodes_in_group('plant')
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			self.add_child(new_plant)
