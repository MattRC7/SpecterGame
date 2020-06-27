extends Node2D

const MAX_LIFE_FORCE = 40
var life_force = 40

func change_health(delta):
	var new_life_force = life_force + delta
	if (delta >= 0):
		life_force = min(MAX_LIFE_FORCE, new_life_force)
		return max(0, new_life_force - MAX_LIFE_FORCE)
	else:
		life_force = max(0, new_life_force)
		return min(0, new_life_force)
	
