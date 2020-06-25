extends Node

signal attack

# Called when the node enters the scene tree for the first time.
func _ready():
	self.emit_signal("attack");
	
func attack():
	get_node("AnimationPlayer").play("attack")
