extends Node2D

const MAX_LIFE_FORCE = 70
var life_force = 70

onready var animator = get_node("AnimationPlayer")

func attack():
	animator.play("attack")
	yield(animator, "animation_finished")

func change_health(delta):
	var old_life_force = life_force
	life_force = max(0, min(MAX_LIFE_FORCE, life_force + delta))
	return life_force - old_life_force

func take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")
	change_health(-10)

func get_health():
	return life_force
