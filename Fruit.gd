class_name Fruit
extends StaticBody2D

var sprite: Sprite;

var ripeness := 0.0;

func _ready():
	sprite = get_node("FruitSprite");
	sprite.visible = is_ripe();

func grow(delta: float):
	ripeness = min(1.0, ripeness+delta);
	if is_ripe(): sprite.visible = true;

func is_ripe():
	return ripeness == 1.0
