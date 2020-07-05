class_name Enemy
extends Node2D

var life_force: LifeForce = LifeForce.new(70, 70)

onready var animator: AnimationPlayer = get_node("AnimationPlayer")

func get_state() -> Dictionary:
	return {
		"life_force": life_force.current
	}

func reset(max_life_force: int, life: int) -> void:
	self.life_force = LifeForce.new(max_life_force, min(max_life_force, life))

func receive_damage(damage: int) -> void:
	assert(damage > 0)
	life_force.change(-damage)

func anim_attack() -> void:
	animator.play("attack")
	yield(animator, "animation_finished")

func anim_take_damage() -> void:
	animator.play("take_damage")
	yield(animator,"animation_finished")
