class_name LabelledLifeBar
extends HBoxContainer

onready var label: Label = get_node("Label")
onready var text_value: Label = get_node("TextValue")
onready var bar: ColorRect = get_node("Bar")

func display(text: String, value: int):
	label.text = text
	text_value.text = str(value)
