extends Node2D

signal water_amount_changed

const SPEED := 600.0;

onready var animator := get_node("StewardAnimator");

export var water_capacity := 10.0;
export var watering_range := 48.0;
var watering := false;
var water := 0.0;

func _ready():
	water = water_capacity;
	emit_signal("water_amount_changed", water);
	animator.play("float")

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position();
	global_position = global_position.move_toward(mouse_position, delta*SPEED) 
	if watering && water > 0:
		water = max(0, water-delta);
		emit_signal("water_amount_changed", water);
		for plant in get_tree().get_nodes_in_group('plant'):
			if plant is Plant:
				if plant.global_position.distance_to(global_position) <= watering_range:
					plant.water.change(delta);
	else:
		if (water < water_capacity):
			water = min(water_capacity, water+delta/2.0);
			emit_signal("water_amount_changed", water);
	update()

func _draw():
	if watering:
		draw_circle(get_viewport().get_mouse_position() - global_position, watering_range, Color(0,0,1,0.5));

func _unhandled_input(event):
	if event.is_action_pressed("game_nourish"):
		print()
		watering = true;
		get_tree().set_input_as_handled()
	elif event.is_action_released("game_nourish"):
		watering = false;
		get_tree().set_input_as_handled()
