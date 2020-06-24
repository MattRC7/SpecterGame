extends Node

const max_life_force = 120
var life_force = 120

func take_damage():
	self.life_force -= 20
	print(self.life_force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Enemy_attack():
	self.take_damage()
