class_name RollingInt
extends Object

var max_val: int;
var min_val: int;
var val: int setget _set_current_val;
var remainder := 0.0;

func _init(maximum: int, minimum := 0, initial := 0):
	max_val = maximum;
	min_val = minimum;
	val = initial;

func _set_current_val(value):
	self.change((value - val) as float);

func change(delta: float):
	remainder = remainder + delta;
	if (abs(remainder) >= 1.0):
		var carryover := floor(remainder) if remainder > 0.0 else ceil(remainder);
		val = max(min_val, min(max_val, val + carryover));
		remainder = remainder - carryover;
