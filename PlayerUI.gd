extends CanvasLayer

onready var health_sprite = get_node("PlayerHP");

func _on_health_changed(percent: float):
	health_sprite.scale = Vector2(percent, health_sprite.scale.y);
