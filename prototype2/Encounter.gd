class_name Encounter
extends Node2D

func _ready():
	get_tree().create_timer(5.0).connect("timeout", self, "attack");

func attack():
	get_tree().call_group("plant", "take_damage", 3)
	get_tree().create_timer(5.0).connect("timeout", self, "attack");

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		if event is InputEventMouse:
			var plant_res: PackedScene = load('res://Plant.tscn');
			var new_plant: Plant = plant_res.instance()
			new_plant.position = event.position
			self.add_child(new_plant)
