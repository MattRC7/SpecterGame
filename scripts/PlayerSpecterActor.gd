class_name PlayerSpecterActor
extends Node2D

onready var sprite: Sprite = get_node("Sprite")
onready var animator: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	sprite.visible = false

func reset(specter: SpecterInstance) -> void:
	sprite.texture = specter.resource.sprite

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
