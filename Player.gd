extends Node2D

const MAX_LIFE_FORCE = 120
var life_force = 80

onready var animator = get_node("AnimationPlayer")
onready var specter = get_node("Specter")

func change_health(delta):
	var old_life_force = life_force
	life_force = max(0, min(MAX_LIFE_FORCE, life_force + delta))
	return life_force - old_life_force

func get_health():
	return { "player": life_force, "specter": specter.life_force }

func rest():
	animator.play("rest")
	yield(animator,"animation_finished")
	change_health(20)
	
func fortify():
	animator.play("fortify")
	yield(animator,"animation_finished")
	var delta = specter.change_health(life_force-1)
	change_health(-delta)

func take_damage():
	animator.play("take_damage")
	yield(animator,"animation_finished")
	var delta = specter.change_health(-12)
	change_health((-12-delta)*2)

func attack():
	animator.play("attack")
	yield(animator, "animation_finished")

func specter_retreat():
	specter.retreat()
	
func awaken():
	specter.awaken()
	var delta = specter.change_health(life_force-1)
	change_health(-delta)

func get_specter_state():
	return specter.state
