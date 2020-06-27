extends Node2D

onready var animator = get_node("AnimationPlayer")

func attack():
	animator.play("attack")
	yield(animator, "animation_finished")
