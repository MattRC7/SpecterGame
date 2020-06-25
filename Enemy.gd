extends Node

signal attack
signal idle
	
func attack():
	get_node("AnimationPlayer").play("attack")
	yield(get_node("AnimationPlayer"), "animation_finished")
	emit_signal("attack")
	emit_signal("idle")
