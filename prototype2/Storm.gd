class_name Storm
extends Node2D

const ATTACK_RANGE := 256.0
const POWER := 2.0

onready var energy_label: Label = get_node("EnergyLabel");

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
	get_tree().create_timer(5.0).connect("timeout", self, "attack", [5.0]);

func attack(delta):
	var plants: Array = get_tree().get_nodes_in_group('plant');
	for plant in plants:
		var distance = self.global_position.distance_to(plant.global_position)
		if distance < ATTACK_RANGE:
			var dist_ratio = pow(ATTACK_RANGE - distance, 2)/pow(ATTACK_RANGE, 2)
			plant.take_damage(POWER*delta*dist_ratio)
	prepare_attack();

func take_damage(damage: float):
	energy.change(-damage)
