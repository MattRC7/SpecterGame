class_name SmartInteger
extends Node;

var max_val := 1 setget _set_max_val;
func _set_max_val(new_max):
	max_val = new_max
	value = int(min(max_val, value))
	
var min_val := 0 setget _set_min_val;
func _set_min_val(new_min):
	min_val = new_min
	value = int(max(min_val, value))

var value := 0 setget _set_current_val;
func _set_current_val(new_value):
	value = int(max(min_val, min(max_val, new_value)))

var remainder := 0.0;

func change(delta: float):
	remainder = remainder + delta;
	if (abs(remainder) >= 1.0):
		var carryover := floor(remainder) if remainder > 0.0 else ceil(remainder);
		_set_current_val(value + carryover);
		remainder = remainder - carryover;
