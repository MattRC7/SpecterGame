extends Control

var labelled_life_bar: PackedScene = load("res://LabelledLifeBar.tscn")

onready var container: VBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer")
onready var game_root: GameRoot = get_node("/root/GameRoot")

func _ready():
	var human_bar: LabelledLifeBar = labelled_life_bar.instance()
	container.add_child(human_bar)
	human_bar.display("Human", game_root.player_life_force)

func _unhandled_key_input(event):
	if (event.is_action_pressed("ui_menu_lifeforce")):
		visible = !visible
		accept_event()
