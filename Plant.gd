class_name Plant
extends StaticBody2D

static func create(plant_res: PlantRes, init_level := 0, init_life := 0, init_water := 0):
	var new_plant: Plant = load('res://Plant.tscn').instance();
	new_plant.plant_resource = plant_res;
	new_plant.initial_level = init_level;
	new_plant.initial_life = init_life;
	new_plant.initial_water = init_water;
	return new_plant;

export var initial_level := 0;
export var initial_life := 0;
export var initial_water := 0;
export var plant_resource: Resource setget _set_resource;
func _set_resource(new_res: Resource):
	if initialized: push_error('Cannot change plant resource after initialization')
	elif new_res is PlantRes: plant_resource = new_res
	else: push_error(
		'plant_resource should be PlantRes: received '+to_json(new_res)
	)

var initialized := false;
var sprite: Sprite;
var hp_label: Label;
var water_label: Label;
var animator: AnimationPlayer;
var water: SmartInteger;
var life: SmartInteger;
var phase_ctrl: PlantPhaseController;

func _ready():
	sprite = get_node("PlantSprite");
	animator = get_node("AnimationPlayer");
	hp_label = get_node("HPLabel");
	water_label = get_node("WaterLabel")
	phase_ctrl = PlantPhaseController.new(plant_resource, initial_level);
	var phase: PlantPhaseRes = phase_ctrl.current_phase()
	_update_sprite(phase.texture);
	water = SmartInteger.new(phase.water_capacity, initial_water);
	life = SmartInteger.new(phase.life_capacity, initial_life);
	var status = phase_ctrl.connect("new_phase", self, "_on_change_phase");
	if status != OK: push_error('Failed to connect plant to new_phases signal: '+status);
	initialized = true

func _on_change_phase():
	var phase = phase_ctrl.current_phase();
	_update_sprite(phase.texture);
	water.max_val = phase.water_capacity
	life.max_val = phase.life_capacity

func _update_sprite(new_texture: StreamTexture):
	sprite.texture = new_texture;
	sprite.offset = Vector2(0, -float(sprite.texture.get_height())/2.0);

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
	water.change(-phase.water_draw*delta)
	if phase_ctrl.is_max_level() && life.value == phase.life_capacity:
		var fruit = get_node_or_null('Fruit');
		if fruit && fruit is Fruit:
			fruit.grow(delta/2.0);
		else:
			fruit = load("res://Fruit.tscn").instance();
			add_child_below_node(sprite, fruit);
	else:
		life.change(phase.growth_rate*delta)
		if life.value >= phase.life_capacity:
			phase_ctrl.current_level += 1

func take_damage(damage: float):
	if phase_ctrl.current_level > 0:
		life.change(-damage)

func drop():
	animator.play('drop')
