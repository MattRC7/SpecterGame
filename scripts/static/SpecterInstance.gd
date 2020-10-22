class_name SpecterInstance
extends Reference

var resource: SpecterResource
var life_force: LifeForce

func _init(init_resource: SpecterResource, current_life_force: int):
	self.resource = init_resource
	self.life_force = LifeForce.new(resource.max_life_force, current_life_force)

func idle_life_force() -> int:
	return self.resource.idle_life_force

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

func get_npc_action() -> String:
	return 'ATTACK'
