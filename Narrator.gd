class_name Narrator
extends Label

signal text_accepted

onready var tween: Tween = get_node("Tween")
onready var timer: Timer = get_node("Timer")

var waiting_for_player := false

func say(text):
	percent_visible = 0
	visible = true
	self.text = text
	tween.interpolate_property(self, "percent_visible", 0, 1, 0.25)
	if not tween.is_active():
		tween.start()
	timer.start()
	yield(self, "text_accepted")

func hide():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("text_accepted")
		accept_event()

func _on_Timer_timeout():
	emit_signal("text_accepted")