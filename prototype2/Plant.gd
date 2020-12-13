class_name Plant
extends Node2D

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");

enum {
	SEED
	PLANT
}

var life = 1;
var state = SEED;

func _ready():
	get_tree().create_timer(3.0).connect("timeout", self, "sprout")

func _process(delta):
	hp_label.text = str(life);

func sprout():
	seed_sprite.visible = false;
	plant_sprite.visible = true;
	life = 10;
	state = PLANT;

func take_damage(damage: int):
	if state == SEED:
		return;
	life = max(0, life - damage);
	if (life == 0):
		self.queue_free()
