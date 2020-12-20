class_name Storm
extends Node2D

const ATTACK_RANGE := 256.0

onready var energy_label: Label = get_node("EnergyLabel");

var energy = 100;

func _ready():
	get_tree().create_timer(5.0).connect("timeout", self, "attack");

func _process(_delta):
	energy_label.text = str(energy);

func attack():
	var plants: Array = get_tree().get_nodes_in_group('plant');
	for plant in plants:
		if self.global_position.distance_to(plant.global_position) <= ATTACK_RANGE:
			plant.take_damage(3)
	get_tree().create_timer(5.0).connect("timeout", self, "attack");

func take_damage(damage: int):
	energy = max(0, energy - damage);
	if (energy == 0):
		self.queue_free()
