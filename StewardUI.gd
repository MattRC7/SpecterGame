extends CanvasLayer

onready var water_label = get_node("MarginContainer/WaterLabel");

func _on_water_amount_changed(amount: float):
	water_label.text = "Vita: "+str(ceil(amount));
