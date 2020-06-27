extends Node2D

const max_life_force = 120
var life_force = 120

onready var animator = get_node("AnimationPlayer")

func change_health(number):
	self.life_force += number
	print(self.life_force)	

func rest():
	animator.play("rest")
	yield(animator,"animation_finished")
	change_health(20);

func take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")
	change_health(-20)	
