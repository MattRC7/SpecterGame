class_name SelectMenu
extends ItemList

func _display_actions(actions: Array) -> void:
	clear()
	for action in actions:
		add_item(action)

func get_player_choice(actions: Array) -> String:
	_display_actions(actions)
	self.visible = true
	var selection_index = yield(self, "item_activated")
	self.visible = false
	return get_item_text(selection_index)
