extends ItemList

signal select_action

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("REST")

func _on_Battle_request_action():
	self.visible = true
	self.connect("item_activated", self, "_on_Self_select_action", [], CONNECT_ONESHOT)
	
func _on_Self_select_action(index):
	self.emit_signal("select_action", self.get_item_text(index))
	self.visible = false
