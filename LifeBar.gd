class_name LifeBar
extends ColorRect

export var MAX_LENGTH := 400.0
onready var tween: Tween = get_node("Tween")
var max_life := 1

func _compute_target_length(life_force: int) -> float:
	var ratio = life_force as float/max_life as float
	return MAX_LENGTH * ratio

func update_bar(life_force: int) -> void:
	var target_length = _compute_target_length(life_force)
	tween.interpolate_property(
		self,
		"margin_right",
		null,
		self.margin_left + target_length as int,
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	if not tween.is_active():
		tween.start()
	yield(tween, "tween_completed")
	
func reset_bar(life_force: LifeForce) -> void:
	self.max_life = life_force.maximum
	var target_length = _compute_target_length(life_force.current)
	self.margin_right = self.margin_left + target_length as int
