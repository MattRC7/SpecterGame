extends Node2D

const SPEED := 600.0;

func _ready():
	position = get_viewport().get_mouse_position();

func _process(delta):
	position = position.move_toward(get_viewport().get_mouse_position(), delta*SPEED) 
