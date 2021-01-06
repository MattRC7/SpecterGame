class_name Plant
extends Node2D

const ATTACK_RANGE := 200.0
export var water_draw := 1.0
export var energy_draw := 1.0
export var growth_rate := 1.0

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");

var level := 0;

var water := RollingInt.new(5);
var life := RollingInt.new(10, 0, 1);

func _process(delta):
	if (life.val == 0):
		self.queue_free()
	grow(delta)
	hp_label.text = str(life.val);

func sprout():
	seed_sprite.visible = false;
	plant_sprite.visible = true;
	level += 1;

func attack(damage: float):
	var storms: Array = get_tree().get_nodes_in_group('storm');
	for storm in storms:
		if self.global_position.distance_to(storm.global_position) < ATTACK_RANGE:
			storm.take_damage(damage)

func grow(delta: float):
	if (!water.val):
		take_damage(growth_rate*0.5*delta)
		return
	if (water.val < water_draw):
		water.change(-water_draw*delta*0.5)
		return
	attack(energy_draw*delta)
	water.change(-water_draw*delta)
	life.change(growth_rate*delta)
	if level == 0 and life.val >= 5:
		sprout()

func take_damage(damage: float):
	if level > 0:
		life.change(-damage)
