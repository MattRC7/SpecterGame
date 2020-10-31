class_name SpecterInstance
extends Reference

var resource: SpecterResource
var abilities: Array
var life_force: LifeForce
var protected := false

func _init(specter_id: int, life_force_percent = 1.0):
	assert(life_force_percent > 0.0 && life_force_percent <= 1.0)
	self.resource = load("res://data/specters/specter_"+str(specter_id)+".tres")
	assert(self.resource)
	resource.init_abilities()
	self.life_force = LifeForce.new(resource.max_life_force, floor(resource.max_life_force*life_force_percent) as int)

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

func buff_cooldown() -> void:
	protected = false

func get_available_abilities() -> Array:
	return self.resource.abilities
