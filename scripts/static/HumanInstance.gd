class_name HumanInstance
extends Reference

var life_force: LifeForce

func _init(max_life_force: int, current_life_force: int):
	self.life_force = LifeForce.new(max_life_force, current_life_force)

func receive_damage(damage: int) -> int:
	assert(damage > 0)
	var initial_life_force = life_force.current
	life_force.change(-damage)
	return initial_life_force - life_force.current

func receive_healing(healing: int) -> int:
	assert(healing > 0)
	var initial_life_force = life_force.current
	life_force.change(healing)
	return life_force.current - initial_life_force
