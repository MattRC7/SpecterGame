class_name Storm
extends Area2D

signal attack

var attacking := false;

func _ready():
	var status = get_tree().create_timer(3.0).connect("timeout", self, '_on_attack_ready');
	if status: push_warning('Failed to connect storm to attack ready event');

func _process(_delta):
	update();

func _on_attack_ready():
	attacking = true;
	emit_signal("attack", 3)
	var status = get_tree().create_timer(1.0).connect("timeout", self, "_on_destroy_self");
	if status: push_warning('Failed to connect storm to destry self event')

func _on_destroy_self():
	attacking = false;
	self.queue_free()

func _draw():
	if attacking:
		draw_circle(Vector2(0,0), 256, Color(1.0, 0.0, 0.0, 0.5));

func _on_body_entered(body):
	if body is Plant:
		var status = self.connect("attack", body, 'take_damage');
		if status: push_warning('Failed to connect plant to storm attack')
