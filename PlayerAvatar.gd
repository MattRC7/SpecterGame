extends Sprite

enum Direction {
	IDLE = 0,
	UP = 1,
	DOWN = 2,
	RIGHT = 3
	LEFT = 4
}

var direction: int = Direction.IDLE
var distance: int = 0

func _unhandled_key_input(event):
	if (distance == 0):
		if (event.is_action_pressed("ui_left", true)):
			_set_direction(Direction.LEFT)

func _set_direction(new_direction: int):
	direction = new_direction
	self.frame = new_direction
	distance = 16
