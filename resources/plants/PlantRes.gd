class_name PlantRes
extends Resource

export var plant_name: String;
export var phases: Array setget _set_phase_array;

func _set_phase_array(new_phases: Array):
	if new_phases.size() == 0:
		push_error("Must set at least one phase in PlantRes");
		phases = []
		return;
	for i in range(new_phases.size()):
		if (not new_phases[i] is PlantPhaseRes):
			push_error("Cannot load "+to_json(new_phases[i])+" as plant phase");
			phases = []
			return;
	phases = new_phases;
