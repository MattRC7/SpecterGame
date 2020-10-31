class_name LifeForce
extends Reference

var maximum := 1 setget _set_maximum
var current := 1 setget _set_current

func _init(maximium: int, initial = 0):
	maximum = maximium
	self._set_current(initial)
	
func _set_maximum(new_maximum: int) -> int:
	maximum = new_maximum
	current = max(0, min(maximum, current)) as int
	return maximum

func _set_current(new_life_force: int) -> int:
	current = max(0, min(maximum, new_life_force)) as int
	return current
	
func change(delta: int) -> int:
	var old_life_force = current
	var new_life_force = _set_current(current + delta)
	return new_life_force - old_life_force

func is_maxed() -> bool:
	return current == maximum
