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

func request_actions(state):
	self.visible = true
	display_actions("PLAYER", state)
	var player_action_index = yield(self, "item_activated")
	self.visible = false
	return { "player": self.get_item_text(player_action_index) }	
