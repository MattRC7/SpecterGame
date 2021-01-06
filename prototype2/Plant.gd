class_name Plant
extends Node2D

const ATTACK_RANGE := 200.0
export var water_draw := 1.0
export var energy_draw := 1.0
export var growth_rate := 2.0

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");

var level := 0;

var water := RollingInt.new(5);

var life := 1;
var life_remainder := 0.0

func _process(delta):
	grow(delta)
	hp_label.text = str(life);

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
	if (water.val <= 0.0):
		take_damage(growth_rate*0.1*delta)
		return
	if (water.val < 1.0):
		water.change(-water_draw*delta/2.0)
		return
	attack(energy_draw*delta)
	water.change(-water_draw*delta)
	life_remainder = life_remainder + max(0, growth_rate*delta);
	if life_remainder > 1.0:
		life = max(0, life + floor(life_remainder));
		life_remainder = life_remainder - floor(life_remainder)
	if level == 0 and life >= 5:
		sprout()

func take_damage(damage: float):
	if level > 0:
		life_remainder = life_remainder - max(0.0, damage);
		if life_remainder < -1.0:
			life = max(0, life + ceil(life_remainder));
			if (life == 0):
				self.queue_free()
			life_remainder = life_remainder - ceil(life_remainder)
