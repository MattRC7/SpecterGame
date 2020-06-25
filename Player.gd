extends Node

signal idle

const max_life_force = 120
var life_force = 120

func change_health(number):
	self.life_force += number
	print(self.life_force)	

func perform_action(action):
	if action == 'REST':
		get_node("AnimationPlayer").play("rest")
		yield(get_node("AnimationPlayer"),"animation_finished")
		change_health(20);
		emit_signal("idle")

func take_damage():
	get_node("AnimationPlayer").play("take_damage")
	yield(get_node("AnimationPlayer"),"animation_finished")
	change_health(-20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Enemy_attack():
	var wait = self.take_damage()
	if wait is GDScriptFunctionState:
		yield(wait, "completed")
	emit_signal("idle")
	
