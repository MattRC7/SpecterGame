extends Control

const LIFE_BAR_MAX_LENGTH = 400.0

onready var player_life_bar = get_node("PlayerLifeBar")
onready var total_life_bar = get_node("TotalLifeBar")
onready var enemy_life_bar = get_node("EnemyLifeBar")
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

func update_life_force(life_force, sequential=false):
	var total_life = life_force.player + life_force.specter
	var wait = total_life_bar.update_life_force(total_life)
	if sequential && wait is GDScriptFunctionState: yield(wait,"completed")
	wait = player_life_bar.update_life_force(life_force.player)
	if wait is GDScriptFunctionState: yield(wait,"completed")

func reset_life_force(life_force):
	max_total_life = life_force.player + life_force.specter
	total_life_bar.reset_life_force(max_total_life, max_total_life)
	player_life_bar.reset_life_force(max_total_life, life_force.player)
	enemy_life_bar.reset_life_force(life_force.enemy, life_force.enemy)

func get_player_actions(state):
	var actions = player_menu.request_actions(state)
	if actions is GDScriptFunctionState:
		actions = yield(actions, "completed")
	return actions
