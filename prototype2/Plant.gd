class_name Plant
extends Node2D

const ATTACK_RANGE := 200.0
const POWER := 2
const ATTACK_FREQUENCY := 3.0

enum {
	SEED
	PLANT
}

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");

var life = 1;
var state = SEED;

func _ready():
	get_tree().create_timer(3.0).connect("timeout", self, "sprout")

func _process(_delta):
	hp_label.text = str(life);

func sprout():
	seed_sprite.visible = false;
	plant_sprite.visible = true;
	life = 10;
	state = PLANT;
	get_tree().create_timer(ATTACK_FREQUENCY).connect("timeout", self, "attack")

func attack():
	var storms: Array = get_tree().get_nodes_in_group('storm');
	for storm in storms:
		if self.global_position.distance_to(storm.global_position) < ATTACK_RANGE:
			storm.take_damage(POWER)
	get_tree().create_timer(ATTACK_FREQUENCY).connect("timeout", self, "attack");

func take_damage(damage: int):
	if state == SEED:
		return;
	life = max(0, life - damage);
	if (life == 0):
		self.queue_free()
