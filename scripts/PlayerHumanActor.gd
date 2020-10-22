class_name PlayerHumanActor
extends Node2D

onready var animator: AnimationPlayer = get_node("AnimationPlayer")

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
