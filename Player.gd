extends Node

signal idle

const max_life_force = 120
var life_force = 120

func take_damage():
	get_node("AnimationPlayer").play("take_damage")
	yield(get_node("AnimationPlayer"),"animation_finished")
	self.life_force -= 20
	print(self.life_force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Enemy_attack():
	var wait = self.take_damage()
	if wait is GDScriptFunctionState:
		yield(wait, "completed")
	emit_signal("idle")
	
