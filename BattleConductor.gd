extends Node2D

signal request_action

# Called when the node enters the scene tree for the first time.
func _ready():
	self.emit_signal("request_action")

func _on_ItemList_select_action(action):
	get_node("Enemy").attack()
	var wait = waitForPlayerAndEnemyIdle()
	if wait is GDScriptFunctionState:
		yield(wait, "completed")
	self.emit_signal("request_action")

func waitForPlayerAndEnemyIdle():
	yield(get_node("Enemy"),"idle")
	yield(get_node("Player"),"idle")
