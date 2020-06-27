extends Node2D

signal execute_turn

onready var enemy = get_node("Enemy")
var player
var gui_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	gui_manager = get_node("GUILayer/GUIManager")
	gui_manager.reset_life_force(player.get_health())
	self.connect("execute_turn", self, "_execute_turn")
	self.emit_signal("execute_turn")

func _execute_turn():
	var actions = gui_manager.get_player_actions()
	if actions is GDScriptFunctionState:
		actions = yield(actions, "completed")

	var wait = enemy.attack()
	if wait is GDScriptFunctionState: yield(wait,"completed")

	wait = player.take_damage()
	if wait is GDScriptFunctionState: yield(wait, "completed")
	wait = gui_manager.update_life_force(player.get_health())
	if wait is GDScriptFunctionState: yield(wait, "completed")

	match actions.player:
		"REST":
			wait = player.rest()
			if wait is GDScriptFunctionState: yield(wait,"completed")
			wait = gui_manager.update_life_force(player.get_health())
			if wait is GDScriptFunctionState: yield(wait, "completed")
		"FORTIFY":
			wait = player.fortify()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = gui_manager.update_life_force(player.get_health())
			if wait is GDScriptFunctionState: yield(wait, "completed")

	self.emit_signal("execute_turn")
