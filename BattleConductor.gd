extends Node2D

signal execute_turn

var enemy
var player
var gui_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	gui_manager = get_node("GUILayer/GUIManager")
	enemy = get_node("Enemy")

	gui_manager.reset_life_force(_get_all_health())

	self.connect("execute_turn", self, "_execute_turn")
	self.emit_signal("execute_turn")
	
func _get_all_health():
	var player_health = player.get_health()
	return {
		"player": player_health.player,
		"specter": player_health.specter,
		"enemy": enemy.get_health()
	}

func _execute_turn():
	var wait
	var specter_initial_state = self.player.get_specter_state()
	var actions = gui_manager.get_player_actions({ "specter": specter_initial_state })
	if actions is GDScriptFunctionState:
		actions = yield(actions, "completed")
		
	# Specter Action
	match actions.specter:
		"ATTACK":
			wait = player.attack()
			if wait is GDScriptFunctionState: yield(wait,"completed")
			wait = enemy.take_damage()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = gui_manager.update_life_force(_get_all_health(), true)
			if wait is GDScriptFunctionState: yield(wait, "completed")

	# Enemy  Action
	wait = enemy.attack()
	if wait is GDScriptFunctionState: yield(wait,"completed")
	wait = player.take_damage()
	if wait is GDScriptFunctionState: yield(wait, "completed")
	wait = gui_manager.update_life_force(_get_all_health(), true)
	if wait is GDScriptFunctionState: yield(wait, "completed")
	var health = player.get_health()
	if health.specter == 0 && specter_initial_state == "ACTIVE":
		wait = player.specter_retreat()
		if wait is GDScriptFunctionState: yield(wait, "completed")

	# Player Action
	match actions.player:
		"REST":
			wait = player.rest()
			if wait is GDScriptFunctionState: yield(wait,"completed")
			wait = gui_manager.update_life_force(_get_all_health())
			if wait is GDScriptFunctionState: yield(wait, "completed")
		"FORTIFY":
			wait = player.fortify()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = gui_manager.update_life_force(_get_all_health())
			if wait is GDScriptFunctionState: yield(wait, "completed")
		"AWAKEN":
			wait = player.awaken()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = gui_manager.update_life_force(_get_all_health())
			if wait is GDScriptFunctionState: yield(wait, "completed")

	self.emit_signal("execute_turn")
