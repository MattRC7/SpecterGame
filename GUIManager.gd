extends Control

const LIFE_BAR_MAX_LENGTH = 400.0

onready var player_life_bar = get_node("PlayerLifeBar")
onready var total_life_bar = get_node("TotalLifeBar")
onready var player_menu = get_node("PlayerMenu")
onready var tween = get_node("Tween")

var max_total_life = 1

func compute_target_lengths(life_force):
	var player_life_force = life_force.player
	var specter_life_force = life_force.specter
	var player_ratio = player_life_force as float/max_total_life as float
	var total_ratio = (player_life_force + specter_life_force) as float/max_total_life as float
	var target_player_length = LIFE_BAR_MAX_LENGTH * player_ratio
	var target_total_length = LIFE_BAR_MAX_LENGTH * total_ratio
	return {"player": target_player_length, "total": target_total_length}	

func update_life_force(life_force):
	var target_lengths = compute_target_lengths(life_force)
	tween.interpolate_property(
		player_life_bar,
		"margin_right",
		null,
		player_life_bar.margin_left + target_lengths.player as int,
		0.6,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		total_life_bar,
		"margin_right",
		null,
		total_life_bar.margin_left + target_lengths.total as int,
		0.6,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	if not tween.is_active():
		tween.start()
	yield(tween, "tween_all_completed")

func reset_life_force(life_force):
	max_total_life = life_force.player + life_force.specter
	var target_lengths = compute_target_lengths(life_force)
	player_life_bar.margin_right = player_life_bar.margin_left + target_lengths.player as int
	total_life_bar.margin_right = total_life_bar.margin_left + target_lengths.total as int


func get_player_actions(state):
	var actions = player_menu.request_actions(state)
	if actions is GDScriptFunctionState:
		actions = yield(actions, "completed")
	return actions
