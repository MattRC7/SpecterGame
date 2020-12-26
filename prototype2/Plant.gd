class_name Plant
extends Node2D

const ATTACK_RANGE := 200.0
export var power := 1.0
export var efficiency := 0.7

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");

var level := 0;
var life := 1;
var life_remainder := 0.0

func _process(delta):
	if (level > 0):
		attack(delta)
	grow(delta)
	hp_label.text = str(life);

func sprout():
	seed_sprite.visible = false;
	plant_sprite.visible = true;
	level += 1;

func attack(delta: float):
	var storms: Array = get_tree().get_nodes_in_group('storm');
	for storm in storms:
		if self.global_position.distance_to(storm.global_position) < ATTACK_RANGE:
			storm.take_damage(power*delta)

func grow(delta: float):
	life_remainder = life_remainder + max(0, power*efficiency*delta);
	if life_remainder > 1.0:
		life = max(0, life + floor(life_remainder));
		life_remainder = life_remainder - floor(life_remainder)
	if level == 0 and life >= 5:
		sprout()

func take_damage(damage: int):
	if level > 0:
		life = max(0, life - damage);
		if (life == 0):
			self.queue_free()
