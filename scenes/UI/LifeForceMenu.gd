extends Control

onready var container: VBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer")
onready var game_root: GameRoot = get_node("/root/GameRoot")

func _ready():
	_refresh_menu()

func _refresh_menu():
	for child in container.get_children():
		child.queue_free()

	_add_bar(
		"Human",
		game_root.compute_player_life_force(),
		game_root.player_total_life_force
	)

	for specter in game_root.bonded_specters:
		_add_bar(
			"Specter",
			specter.resource.idle_life_force
		)

func _add_bar(label: String, life_force: int, max_lf = 0):
	var labelled_life_meter: PackedScene = load("res://scenes/UI/LabelledLifeMeter.tscn")
	var bar: LabelledLifeMeter = labelled_life_meter.instance()
	container.add_child(bar)
	bar.display(label, life_force, max_lf)

func _unhandled_key_input(event):
	if (event.is_action_pressed("ui_menu_lifeforce")):
		visible = !visible
		if visible: _refresh_menu()
		accept_event()
