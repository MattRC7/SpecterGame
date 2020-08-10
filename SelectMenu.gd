class_name SelectMenu
extends BoxContainer

var options: ItemList
onready var description: Label = get_node("SelectMenuOptionText")

func _ready():
	options = get_node("SelectMenuOptions")

func _display_actions(actions: Array) -> void:
	options.clear()
	for action in actions:
		options.add_item(action.text)

func _display_action_description(index: int, actions: Array):
	description.text = actions[index].description

func get_player_choice(actions: Array) -> String:
	_display_actions(actions)
	options.visible = true
	description.visible = true
	options.connect("item_selected", self, "_display_action_description", [actions])
	options.select(0)
	_display_action_description(0, actions)
	var selection_index = yield(options, "item_activated")
	options.disconnect("item_selected", self, "_display_action_description")
	options.visible = false
	description.visible = false
	return actions[selection_index].key
