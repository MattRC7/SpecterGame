class_name Player
extends Node2D

signal plant_seed;

const UP := 'player_up';
const DOWN := 'player_down';
const LEFT := 'player_left';
const RIGHT := 'player_right';

const SPEED := 256.0

onready var seed_planter = get_node("SeedPlanter");

var pressed := {
	UP: false,
	DOWN: false,
	LEFT: false,
	RIGHT: false,
};

func _process(delta):
	var y_move = (1 if pressed[DOWN] else 0) - (1 if pressed[UP] else 0)
	var x_move = (1 if pressed[RIGHT] else 0) - (1 if pressed[LEFT] else 0)
	var move := Vector2(x_move, y_move).normalized()*SPEED;
	position = position.move_toward(position + move, delta*SPEED);

func _unhandled_input(event):
	if event.is_action_pressed("game_sow"):
		var new_plant = seed_planter.plant_seed();
		emit_signal("plant_seed", new_plant, position + Vector2(0, 16));
		get_viewport().set_input_as_handled();
	return;

func _unhandled_key_input(event):
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
