extends Component

class_name BasicComponent


func _init(_input, _type, children):
	type = _type
	input = _input
	for child in children:
		add_child(child)

func get_control(value):
	for child in get_children():
		if child.input.has("id"):
			if child.input.id == value:
				return child.control
		return child.get_control(value)

func get_data():
	var children_data = []
	for child in get_children():
		print(child)
		children_data.append(child.get_data())

	var data = {
		"type": type,
		"input": input,
		"children": children_data,
		"control": control
	}
	return data
