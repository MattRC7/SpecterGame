extends ItemList

func display_actions(menu, state):
	self.clear()
	match menu:
		"PLAYER":
			self.add_item("REST")
			if state.specter == "ACTIVE":
				self.add_item("FORTIFY")
			else:
				self.add_item("AWAKEN")
		"SPECTER":
			self.add_item("ATTACK")

func request_actions(state):
	self.visible = true
	var specter_action = ""
	if (state.specter == "ACTIVE"):
		display_actions("SPECTER", state)
		var specter_action_index = yield(self, "item_activated")
		specter_action = self.get_item_text(specter_action_index)
	display_actions("PLAYER", state)
	var player_action_index = yield(self, "item_activated")
	self.visible = false
	return {
		"player": self.get_item_text(player_action_index),
		"specter": specter_action
	}	
