class_name LabelledLifeMeter
extends HBoxContainer

onready var label: Label = get_node("Label")
onready var text_value: Label = get_node("TextValue")

func display(text: String, value: int, max_value = 0):
	label.text = text
	if (max_value > 0):
		text_value.text = str(value) + '/' + str(max_value)
	else:
		text_value.text = str(value)
