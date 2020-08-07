class_name DialogBox
extends PanelContainer

export var dialog_pace := 2.0

onready var narrator: Narrator = get_node("DialogMargin/Narrator")
onready var select_menu: SelectMenu = get_node("DialogMargin/SelectMenu")

func get_player_choice(options: Array) -> String:
	narrator.hide()
	var selection = select_menu.get_player_choice(options);
	if selection is GDScriptFunctionState:
		selection = yield(selection, "completed")
	return selection
	
func say(text: String, time = -1) -> void:
	var wait = narrator.say(text, time if time > 0 else dialog_pace)
	if wait is GDScriptFunctionState: yield(wait, "completed")
