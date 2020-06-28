class_name LifeForce
extends Object

var maximum := 1 setget _set_maximum
var current := 1 setget _set_current, _get_current

func _set_maximum(value: int) -> int:
	return maximum

func _init(maximium: int, initial = 0):
	maximum = maximium
	current = initial
	
func _get_current() -> int:
	return current
	
func _set_current(new_life_force: int) -> int:
	current = max(0, min(maximum, new_life_force))
	return current
	
func change(delta: int) -> int:
	var old_life_force = current
	var new_life_force = _set_current(current + delta)
	return new_life_force - old_life_force

func is_maxed() -> bool:
	return current == maximum
