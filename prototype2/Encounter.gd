class_name Encounter
extends Node2D

const MAX_PLANTS := 3

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		if len(get_tree().get_nodes_in_group('plant')) >= MAX_PLANTS :
			return
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			self.add_child(new_plant)
