extends ItemList

const player_actions = [
	"REST",
	"FORTIFY"
]

func display_actions(actions):
	self.clear()
	for action in actions:
		self.add_item(action)

func request_actions():
	self.visible = true
	display_actions(player_actions)
	var player_action_index = yield(self, "item_activated")
	self.visible = false
	return { "player": player_actions[player_action_index] }	
