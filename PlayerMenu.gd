class_name PlayerMenu
extends ItemList

func display_actions(menu: String, state: Dictionary) -> Array:
	var actions = []
	clear()
	match menu:
		"PLAYER":
			add_item("REST")
			actions.append("REST")
			if state.specter.awake:
				add_item("FORTIFY")
				actions.append("FORTIFY")
			else:
				add_item("AWAKEN")
				actions.append("AWAKEN")
		"SPECTER":
			add_item("ZAP")
			actions.append("ATTACK")
	return actions

func request_actions(state: Dictionary):
	self.visible = true
	var specter_action = ""
	if (state.specter.awake):
		var action_keys = display_actions("SPECTER", state)
		var specter_action_index = yield(self, "item_activated")
		specter_action = action_keys[specter_action_index]
	var action_keys = display_actions("PLAYER", state)
	var player_action_index = yield(self, "item_activated")
	self.visible = false
	return {
		"player": action_keys[player_action_index],
		"specter": specter_action
	}	
