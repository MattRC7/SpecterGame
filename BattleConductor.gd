extends Node2D

signal request_action

# Called when the node enters the scene tree for the first time.
func _ready():
	self.emit_signal("request_action")

func _on_ItemList_select_action(action):
	get_node("Enemy").attack()
	yield(get_node("Enemy"),"idle")
	yield(get_node("Player"),"idle")

	get_node("Player").perform_action(action)
	yield(get_node("Player"),"idle")

	self.emit_signal("request_action")
