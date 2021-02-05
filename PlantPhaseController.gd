class_name PlantPhaseController
extends Object

signal new_phase

var phases: Array;
var current_level := 0 setget _set_level;
func _set_level(new_level: int):
	var old_level = current_level;
	current_level = int(max(0, min(max_level(), new_level)));
	if phases[current_level] != phases[old_level]:
		emit_signal("new_phase")

func _init(plant_res: PlantRes, initial_level = 0):
	current_level = initial_level;
	phases = plant_res.phases;

func is_max_level() -> bool:
	return current_level == max_level();

func max_level() -> int:
	return phases.size() if phases else 0;

func current_phase() -> PlantPhaseRes:
	return phases[current_level] if phases && phases[current_level] else null;
