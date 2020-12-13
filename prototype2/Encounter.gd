class_name Encounter
extends Node2D

func _ready():
	get_tree().create_timer(5.0).connect("timeout", self, "attack");

func attack():
	get_tree().call_group("plant", "take_damage", 5)
	get_tree().create_timer(5.0).connect("timeout", self, "attack");
