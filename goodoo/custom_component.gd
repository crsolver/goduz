extends Component

class_name CustomComponent

var state:Dictionary
var container
var parent_control

func _init(_type, _input={}):
	type = _type
	input = _input.duplicate(true)
	control = Node.new()
	container = Node.new()
	add_child(control)
	add_child(container)


func complete():
	# creates the component tree based on its render method
	container.add_child(gui())


func get_gui():
	return container.get_children()[0]


func update_gui():
	var next = gui()
	Goodoo.diff(self.get_gui(), next)



func gui():
	pass


func get_data():
	# Return the component tree as a dictionary.
	var data = {
		"type": type,
		"input": input,
		"control": control,
		"container": container,
		"parent_control": parent_control,
		"children": get_gui().get_data(),
	}
	return data


func get_control(value):
	var _gui = get_gui()
	if _gui.input.has("id"):
		if _gui.input.id == value:
			return _gui.control
	return _gui.get_control(value)
