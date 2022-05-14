extends Component

class_name BasicComponent


func _init(_input, _type, children):
	type = _type
	input = _input
	for child in children:
		add_child(child)

func get_components():
	return get_children()
