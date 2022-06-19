extends Component

class_name BasicComponent

var list = false
var key = null

func _init(_input:Dictionary, _type:String, children:Array):
	type = _type
	input = _input.duplicate(true)

	if input.has("list"):
		list = input.list

	if input.has("key"):
		key = input.key

	for child in children:
		add_child(child)


func get_control(value):
	for child in get_children():
		if child.input.has("id"):
			if child.input.id == value:
				return child.control
		var found = child.get_control(value)
		if found:
			return found
	return null


func get_data():
	var children_data = []
	for child in get_children():
		children_data.append(child.get_data())

	var data = {
		"type": type,
		"input": input,
		"children": children_data,
		"control": control,
		"parent": control.get_parent()
	}
	return data
