extends Node2D

signal request_action

onready var enemy = get_node("Enemy")
onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.emit_signal("request_action")

func _on_ItemList_select_action(action):
	var wait = enemy.attack()
	if wait is GDScriptFunctionState: yield(wait,"completed")
	wait = player.take_damage()
	if wait is GDScriptFunctionState: yield(wait, "completed")

	wait = player.rest()
	if wait is GDScriptFunctionState: yield(wait,"completed")

	self.emit_signal("request_action")
