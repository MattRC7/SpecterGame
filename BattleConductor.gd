extends Node2D

signal request_action

onready var enemy = get_node("Enemy")
var player
var gui_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	gui_manager = get_node("GUILayer/GUIManager")
	gui_manager.reset_life_force(player.MAX_LIFE_FORCE)
	self.emit_signal("request_action")

func _on_ItemList_select_action(action):
	var wait = enemy.attack()
	if wait is GDScriptFunctionState: yield(wait,"completed")

	var health = player.take_damage()
	if health is GDScriptFunctionState: health = yield(health, "completed")

	wait = gui_manager.update_life_force(health)
	if wait is GDScriptFunctionState: yield(wait, "completed")

	health = player.rest()
	if health is GDScriptFunctionState: health = yield(health,"completed")

	wait = gui_manager.update_life_force(health)
	if wait is GDScriptFunctionState: yield(wait, "completed")

	self.emit_signal("request_action")
