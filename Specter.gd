class_name Specter
extends Node2D

onready var sprite: Sprite = get_node("Sprite")
onready var animator: AnimationPlayer = get_node("AnimationPlayer")

var life_force: LifeForce = LifeForce.new(40, 40)

var awake := true

func get_state() -> Dictionary:
	return {
		"life_force": life_force.current,
		"awake": awake
	}
	
func receive_damage(damage: int) -> void:
	assert(damage > 0)
	if (awake):
		life_force.change(-damage)
		if (life_force.current) == 0:
			awake = false

func receive_healing(healing: int) -> void:
	assert(healing > 0)
	if (awake):
		life_force.change(healing)
	
func receive_awaken(life_force) -> void:
	if (!awake && life_force > 0):
		awake = true
		receive_healing(life_force)

func anim_retreat() -> void:
	sprite.visible = true
	animator.play("retreat")
	yield(animator, "animation_finished")
	sprite.visible = false
	
func anim_awaken() -> void:
	sprite.visible = true
	animator.play_backwards("retreat")
	yield(animator, "animation_finished")
	sprite.visible = false
