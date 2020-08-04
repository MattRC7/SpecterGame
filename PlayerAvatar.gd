class_name PlayerAvatar
extends Sprite

const speed = 4.0

enum Direction {
	DOWN = 0,
	UP = 1,
	RIGHT = 2
	LEFT = 3
}

onready var tween = get_node("Tween")

var direction: int = Direction.UP
var frozen := false

func _unhandled_key_input(event):
	if (!frozen && !tween.is_active()):
		if (event.is_action_pressed("ui_left", true)):
			set_direction(Direction.LEFT)
			tween.interpolate_property(self, "position", null, Vector2(self.position.x - 16, self.position.y), 1.0/speed, Tween.TRANS_LINEAR)
		if (event.is_action_pressed("ui_right", true)):
			set_direction(Direction.RIGHT)
			tween.interpolate_property(self, "position", null, Vector2(self.position.x + 16, self.position.y), 1.0/speed, Tween.TRANS_LINEAR)
		if (event.is_action_pressed("ui_up", true)):
			set_direction(Direction.UP)
			tween.interpolate_property(self, "position", null, Vector2(self.position.x, self.position.y - 16), 1.0/speed, Tween.TRANS_LINEAR)
		if (event.is_action_pressed("ui_down", true)):
			set_direction(Direction.DOWN)
			tween.interpolate_property(self, "position", null, Vector2(self.position.x, self.position.y + 16), 1.0/speed, Tween.TRANS_LINEAR)
		if (!tween.is_active()):
			tween.start()

func set_direction(new_direction: int):
	direction = new_direction
	self.frame = new_direction
