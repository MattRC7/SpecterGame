class_name Player
extends Node2D

signal health_changed

const UP := 'player_up';
const DOWN := 'player_down';
const LEFT := 'player_left';
const RIGHT := 'player_right';

const SPEED := 256.0

var picking_area: Area2D;
var pickable_fruit := [];
export var health_capacity := 10;
var health := 10.0;

var pressed := {
	UP: false,
	DOWN: false,
	LEFT: false,
	RIGHT: false,
};

func _ready():
	picking_area = get_node("PickingArea");
	var status = picking_area.connect("body_entered", self, "_on_detect_fruit");
	if status != OK:
		push_error('Could not connect Player to Area2D event');
	status = picking_area.connect("body_exited", self, "_on_exit_fruit");
	if status != OK:
		push_error('Could not connect Player to Area2D event');
	health = float(health_capacity)
	emit_signal("health_changed", health/float(health_capacity));

func _process(delta):
	var y_move = (1 if pressed[DOWN] else 0) - (1 if pressed[UP] else 0)
	var x_move = (1 if pressed[RIGHT] else 0) - (1 if pressed[LEFT] else 0)
	var move := Vector2(x_move, y_move).normalized()*SPEED;
	position = position.move_toward(position + move, delta*SPEED);
	health = max(0, health-delta/4.0);
	emit_signal("health_changed", health/float(health_capacity))

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		var new_plant = Plant.create(GameData.Plants.DEMO_PLANT, 0, 0, 0);
		new_plant.position = position + Vector2(16, 16);
		get_parent().add_child(new_plant);
		new_plant.drop()
		get_viewport().set_input_as_handled();
	return;

func _unhandled_key_input(event):
	if event.is_action_released("game_pick_fruit"):
		var fruit_to_pick = null;
		for fruit in pickable_fruit:
			if fruit.is_ripe():
				if !fruit_to_pick:
					fruit_to_pick = fruit;
				else:
					var current_dist = fruit_to_pick.global_position.distance_to(global_position);
					var to_pick_dist = fruit.global_position.distance_to(global_position);
					if to_pick_dist < current_dist:
						fruit_to_pick = fruit;
		if fruit_to_pick is Fruit:
			health = min(float(health_capacity), health+3.0)
			emit_signal("health_changed", health/float(health_capacity))
			pickable_fruit.remove(pickable_fruit.find(fruit_to_pick));
			fruit_to_pick.queue_free();
		return;
	for action in [UP, DOWN, LEFT, RIGHT]:
		if (_handle_movement_input(event, action)): return

func _handle_movement_input(event: InputEventKey, action):
	if (event.is_action_pressed(action)):
		pressed[action] = true
		get_tree().set_input_as_handled()
		return true;
	if (event.is_action_released(action)):
		pressed[action] = false
		get_tree().set_input_as_handled()
		return true;
	return false;

func _on_detect_fruit(fruit: Node):
	if !pickable_fruit.has(fruit):
		pickable_fruit.append(fruit);

func _on_exit_fruit(fruit: Node):
	var index = pickable_fruit.find(fruit);
	if index >= 0:
		pickable_fruit.remove(index);
