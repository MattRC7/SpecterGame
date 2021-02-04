class_name Plant
extends Node2D

var sprite: Sprite;
var hp_label: Label;
var water_label: Label;
var animator: AnimationPlayer;
var water: SmartInteger;
var life: SmartInteger;
var phase_ctrl: PlantPhaseController;

var spec: PlantRes setget _set_spec;
func _set_spec(new_spec: PlantRes):
	spec = new_spec;
	if phase_ctrl: phase_ctrl.add_phases_from_spec(spec)

static func create(plant_spec: PlantRes, initial_level := 0, initial_life := 0, initial_water := 0):
	var plant_scene: PackedScene = load('res://Plant.tscn');
	var new_plant: Plant = plant_scene.instance();
	new_plant.spec = plant_spec;
	new_plant.phase_ctrl.current_level = initial_level;
	new_plant.life.value = initial_life;
	new_plant.water.value = initial_water;
	return new_plant;

func _notification(what):
	if what == NOTIFICATION_INSTANCED:
		_setup_nodes_and_signals();

func _ready():
	_setup_nodes_and_signals();
	animator.play('drop');

func _setup_nodes_and_signals():
	sprite = get_node("PlantSprite");
	animator = get_node("AnimationPlayer");
	hp_label = get_node("HPLabel");
	water_label = get_node("WaterLabel")
	water = get_node("Water");
	life = get_node("Life");
	phase_ctrl = get_node("PlantPhaseController");
	if !phase_ctrl.is_connected("new_phase", self,"_on_change_phase"):
		var status = phase_ctrl.connect("new_phase", self, "_on_change_phase");
		if status != OK: push_error('Failed to connect plant to new_phases signal: '+status);

func _on_change_phase():
	var phase: PlantPhaseRes = phase_ctrl.current_phase()
	sprite.texture = phase.texture
	sprite.offset = Vector2(0, -float(sprite.texture.get_height())/2.0);
	water.max_val = phase.water_capacity
	life.max_val = phase.life_capacity

func _process(delta):
	var level = phase_ctrl.current_level
	var phase = phase_ctrl.current_phase()
	if (level > 0 && life.value == 0):
		self.queue_free()

	grow(delta)

	var water_indicator;
	if water.value == water.max_val: water_indicator = 'FULL'
	elif water.value > (water.max_val as float)/2.0: water_indicator = 'OKAY'
	elif water.value > (phase.water_draw): water_indicator = 'THIRSTY'
	elif water.value > 0 or level == 0: water_indicator = 'DRY'
	else: water_indicator = 'DYING'
		
	hp_label.text = 'HP: ' + str(life.value) + ' (Lv. ' + str(level) + ' ) ';
	water_label.text = 'VITA: ' + str(water.value) + ' ( ' + water_indicator + ' )';

func grow(delta: float):
	var phase = phase_ctrl.current_phase();
	if (!water.value):
		take_damage(phase.growth_rate*0.5*delta)
		return
	if (water.value < phase.water_draw):
		water.change(-phase.water_draw*delta*0.5)
		return
	attack(phase.energy_draw*delta)
	water.change(-phase.water_draw*delta)
	life.change(phase.growth_rate*delta)
	if not phase_ctrl.is_max_level() and life.value >= phase.life_capacity:
		phase_ctrl.current_level += 1

func attack(damage: float):
	var storms: Array = get_tree().get_nodes_in_group('storm');
	for storm in storms:
		if self.global_position.distance_to(storm.global_position) < phase_ctrl.current_phase().energy_draw_range:
			storm.take_damage(damage)

func take_damage(damage: float):
	if phase_ctrl.current_level > 0:
		life.change(-damage)
