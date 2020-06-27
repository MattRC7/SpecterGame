extends Node2D

onready var sprite = get_node("Sprite")
onready var animator = get_node("AnimationPlayer")

const MAX_LIFE_FORCE = 40
var life_force = 40
var state = "ACTIVE"

func change_health(delta):
	var old_life_force = life_force
	life_force = max(0, min(MAX_LIFE_FORCE, life_force + delta))
	return life_force - old_life_force

func retreat():
	sprite.visible = true
	animator.play("retreat")
	yield(animator, "animation_finished")
	sprite.visible = false
	self.state = "SLEEP"
	
func awaken():
	sprite.visible = true
	animator.play_backwards("retreat")
	yield(animator, "animation_finished")
	sprite.visible = false
	self.state = "ACTIVE"
