class_name Plant
extends Node2D

var energy_draw_range := 200.0
var water_draw := 1.0
var energy_draw := 1.0
var growth_rate := 1.0

onready var plant_sprite: Sprite = get_node("PlantSprite");
onready var seed_sprite: Sprite = get_node("SeedSprite");
onready var hp_label: Label = get_node("HPLabel");
onready var water_label: Label = get_node("WaterLabel")

var level := 0;

var water := RollingInt.new(0);
var life := RollingInt.new(0);

func _process(delta):
	if (level > 0 && life.val == 0):
		self.queue_free()
	grow(delta)

	var water_indicator;
	if water.val == water.max_val: water_indicator = 'FULL'
	elif water.val > (water.max_val as float)/2.0: water_indicator = 'OKAY'
	elif water.val > (water_draw): water_indicator = 'THIRSTY'
	elif water.val > 0 or level == 0: water_indicator = 'DRY'
	else: water_indicator = 'DYING'
		
	hp_label.text = 'HP: ' + str(life.val) + ' (Lv. ' + str(level) + ' ) ';
	water_label.text = 'VITA: ' + str(water.val) + ' ( ' + water_indicator + ' )';

func sprout():
	seed_sprite.visible = false;
	plant_sprite.visible = true;
	level += 1;

func attack(damage: float):
	var storms: Array = get_tree().get_nodes_in_group('storm');
	for storm in storms:
		if self.global_position.distance_to(storm.global_position) < energy_draw_range:
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
	if level == 0 and life.val >= 4:
		sprout()

func take_damage(damage: float):
	if level > 0:
		life.change(-damage)
