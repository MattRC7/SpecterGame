extends Node2D

const MAX_LIFE_FORCE = 120
var life_force = 120

onready var animator = get_node("AnimationPlayer")

func change_health(number):
	life_force = min(MAX_LIFE_FORCE, life_force + number)

func rest():
	animator.play("rest")
	yield(animator,"animation_finished")
	change_health(20);
	return life_force

func take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")
	change_health(-20)
	return life_force
