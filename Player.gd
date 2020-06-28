class_name Player
extends Node2D

var life_force: LifeForce = LifeForce.new(120, 80)

onready var animator: AnimationPlayer = get_node("AnimationPlayer")
onready var specter: Specter = get_node("Specter")

func get_state() -> Dictionary:
	return {
		"life_force": life_force.current,
		"specter": specter.get_state()
	}

func receive_damage(damage: int):
	assert(damage > 0)
	life_force.change(-damage)
	return get_state()
	
func receive_healing(healing: int):
	assert(healing > 0)
	life_force.change(healing)
	return get_state()

func anim_rest():
	animator.play("rest")
	yield(animator,"animation_finished")
	
func anim_fortify():
	animator.play("fortify")
	yield(animator,"animation_finished")

func anim_take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")

func anim_attack():
	animator.play("attack")
	yield(animator, "animation_finished")
