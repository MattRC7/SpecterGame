class_name Specter
extends Node2D

onready var sprite: Sprite = get_node("Sprite")
onready var animator: AnimationPlayer = get_node("AnimationPlayer")

var life_force: LifeForce

var awake := true

func _ready():
	sprite.visible = false

func get_state() -> Dictionary:
	return {
		"life_force": life_force.current,
		"awake": awake
	}
	
func reset(max_life = 0, life = 0, wake = false):
	self.awake = wake
	self.life_force = LifeForce.new(max_life, min(max_life, life))
	
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

func anim_retreat() -> void:
	animator.play("retreat")
	yield(animator, "animation_finished")
	
func anim_awaken() -> void:
	animator.play("awaken")
	yield(animator, "animation_finished")
	
func anim_attack() -> void:
	animator.play("attack")
	yield(animator, "animation_finished")

func anim_fortify() -> void:
	animator.play("fortify")
	yield(animator, "animation_finished")
