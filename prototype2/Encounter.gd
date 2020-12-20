class_name Encounter
extends Node2D

var sow_cooldown := 0.0;

func _process(delta):
	sow_cooldown = max(0, sow_cooldown - delta);

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		if sow_cooldown > 0:
			return
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			self.add_child(new_plant)
			sow_cooldown = 5.0
