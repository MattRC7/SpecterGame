class_name PlayerAvatar
extends Sprite

const speed = 4.0

enum Direction {
	DOWN = 0,
	UP = 1,
	RIGHT = 2
	LEFT = 3
}

var direction: int = Direction.UP
var target_space: Vector2
var frozen := false

func _ready():
	target_space = self.position

func _process(delta):
	if (target_space != self.position):
		self.position = self.position.move_toward(target_space, 64*delta)

func _unhandled_key_input(event):
	if !frozen:
		if (target_space == self.position):
			if (event.is_action("ui_left")):
				set_direction(Direction.LEFT)
				target_space = self.position + Vector2(-16, 0)
			if (event.is_action("ui_right")):
				set_direction(Direction.RIGHT)
				target_space = self.position + Vector2(16, 0)
			if (event.is_action("ui_up")):
				set_direction(Direction.UP)
				target_space = self.position + Vector2(0, -16)
			if (event.is_action("ui_down")):
				set_direction(Direction.DOWN)
				target_space = self.position + Vector2(0, 16)

func set_direction(new_direction: int):
	direction = new_direction
	self.frame = new_direction
