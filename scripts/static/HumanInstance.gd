class_name HumanInstance
extends Reference

var life_force: LifeForce
var scared := false setget _set_scared, _get_scared
var scared_cooldown := 0

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

func _set_scared(scared_val: bool) -> bool:
	if (scared && !scared_val):
		scared = false
	if (!scared && scared_val && scared_cooldown == 0):
		scared = true
	return scared

func _get_scared() -> bool:
	return scared

func buff_cooldown() -> void:
	if (scared_cooldown > 0):
		scared_cooldown -= 1

func debuff_cooldown() -> void:
	if (scared):
		scared = false
		scared_cooldown = 2
