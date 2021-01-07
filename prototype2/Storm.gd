class_name Storm
extends Node2D

onready var energy_label: Label = get_node("EnergyLabel");

export var attack_range := 256.0
export var attack_power := 1.0
export var attack_frequency := 2.5;
export var attack_dropoff := 1.0;

export var max_energy := 1;
var energy: RollingInt;

func _ready():
	energy = RollingInt.new(max_energy, 0.0, max_energy);
	prepare_attack();

func _process(_delta):
	if (energy.val == 0):
		self.queue_free()
	energy_label.text = str(energy.val);

func prepare_attack():
	get_tree().create_timer(attack_frequency).connect(
		"timeout", self, "attack", [attack_frequency]
	);

func attack(delta):
	var plants: Array = get_tree().get_nodes_in_group('plant');
	for plant in plants:
		var distance = self.global_position.distance_to(plant.global_position)
		if distance < attack_range:
			var dist_ratio = pow(attack_range - distance, 2)/pow(attack_range, 2)
			plant.take_damage(attack_power*delta*dist_ratio)
	prepare_attack();

func take_damage(damage: float):
	energy.change(-damage)
