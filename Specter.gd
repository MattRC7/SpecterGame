extends Node2D

const MAX_LIFE_FORCE = 40
var life_force = 40
var state = "ACTIVE"

func change_health(delta):
	var old_life_force = life_force
	life_force = max(0, min(MAX_LIFE_FORCE, life_force + delta))
	return life_force - old_life_force

func retreat():
	self.state = "SLEEP"

func awaken():
	self.state = "ACTIVE"
