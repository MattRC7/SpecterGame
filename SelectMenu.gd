class_name SelectMenu
extends BoxContainer

var options: ItemList
var action_list: Array
onready var description: Label = get_node("SelectMenuOptionText")

func _ready():
	options = get_node("SelectMenuOptions")

func _display_actions() -> void:
	options.clear()
	for action in action_list:
		options.add_item(action.text)

func _display_action_description(index: int):
	description.text = action_list[index].description

func get_player_choice(actions: Array) -> String:
	action_list = actions
	_display_actions()
	options.visible = true
	description.visible = true
	options.connect("item_selected", self, "_display_action_description")
	options.select(0)
	_display_action_description(0)
	var selection_index = yield(options, "item_activated")
	options.disconnect("item_selected", self, "_display_action_description")
	options.visible = false
	description.visible = false
	return action_list[selection_index].key
