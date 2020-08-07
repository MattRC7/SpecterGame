class_name Enemy
extends Node2D

var life_force: LifeForce = LifeForce.new(70, 70)
var bonded := false

onready var animator: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite3")

func get_state() -> Dictionary:
	return {
		"life_force": life_force.current
	}

func reset(resource: SpecterResource, life: int) -> void:
	sprite.texture = resource.sprite
	self.life_force = LifeForce.new(resource.max_life_force, min(resource.max_life_force, life))

func receive_damage(damage: int) -> void:
	assert(damage > 0)
	life_force.change(-damage)

func anim_attack() -> void:
	animator.play("attack")
	yield(animator, "animation_finished")

func anim_take_damage() -> void:
	animator.play("take_damage")
	yield(animator,"animation_finished")
	
func anim_bond() -> void:
	animator.play("bond")
	yield(animator, "animation_finished")
