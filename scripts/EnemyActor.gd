class_name EnemyActor
extends Node2D

onready var animator: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite3")

func reset(specter: SpecterInstance) -> void:
	sprite.texture = specter.resource.sprite

func anim_attack() -> void:
	animator.play("attack")
	yield(animator, "animation_finished")

func anim_take_damage() -> void:
	animator.play("take_damage")
	yield(animator,"animation_finished")
	
func anim_bond() -> void:
	animator.play("bond")
	yield(animator, "animation_finished")
