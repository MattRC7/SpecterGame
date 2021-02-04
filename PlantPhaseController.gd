class_name PlantPhaseController
extends Node

signal new_phase

var phases: Array setget _set_phases;
func _set_phases(_new_phases: Array): pass; # use add_phases_from_spec
	
var current_level := 0 setget _set_level;
func _set_level(new_level: int):
	var old_level = current_level;
	current_level = int(max(0, min(max_level(), new_level)));
	if phases && phases[current_level] != phases[old_level]:
		emit_signal("new_phase")

func add_phases_from_spec(spec: PlantRes):
	phases = spec.phases;
	emit_signal("new_phase");

func is_max_level() -> bool:
	return current_level == max_level();

func max_level() -> int:
	return phases.size() if phases else 0;

func current_phase() -> PlantPhaseRes:
	return phases[current_level] if phases && phases[current_level] else null;
