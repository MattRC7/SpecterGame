extends Node2D

const MAX_LIFE_FORCE = 120
var life_force = 80

onready var animator = get_node("AnimationPlayer")
onready var specter = get_node("Specter")

func change_health(delta):
	var new_life_force = life_force + delta
	if (delta >= 0):
		life_force = min(MAX_LIFE_FORCE, new_life_force)
		return max(0, new_life_force - MAX_LIFE_FORCE)
	else:
		life_force = max(0, new_life_force)
		return min(0, new_life_force)

func get_health():
	return { "player": life_force, "specter": specter.life_force }

func rest():
	animator.play("rest")
	yield(animator,"animation_finished")
	change_health(20)

func take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")
	var remaining_damage = specter.change_health(-12)
	change_health(remaining_damage * 2)

func attack():
	animator.play("attack")
	yield(animator, "animation_finished")
