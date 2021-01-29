extends Node2D

const SPEED := 600.0;

onready var animator := get_node("StewardAnimator");

func _ready():
	animator.play("float")

func _process(delta):
	position = position.move_toward(get_viewport().get_mouse_position(), delta*SPEED) 
