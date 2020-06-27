extends Node2D

signal request_action

onready var enemy = get_node("Enemy")
var player
var gui_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	gui_manager = get_node("GUILayer/GUIManager")
	gui_manager.reset_life_force(player.get_health())
	self.emit_signal("request_action")

func _on_ItemList_select_action(action):
	var wait = enemy.attack()
	if wait is GDScriptFunctionState: yield(wait,"completed")

	wait = player.take_damage()
	if wait is GDScriptFunctionState: yield(wait, "completed")

	wait = gui_manager.update_life_force(player.get_health())
	if wait is GDScriptFunctionState: yield(wait, "completed")

	wait = player.rest()
	if wait is GDScriptFunctionState: yield(wait,"completed")

	wait = gui_manager.update_life_force(player.get_health())
	if wait is GDScriptFunctionState: yield(wait, "completed")

	self.emit_signal("request_action")
