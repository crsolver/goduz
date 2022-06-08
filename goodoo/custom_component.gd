extends Component

class_name CustomComponent

var state:Dictionary
var container
var parent_control
var extras

func _init(_type, _input={}):
	type = _type
	input = _input
	extras = Node.new()
	container = Node.new()
	add_child(extras)
	add_child(container)

func complete():
	# creates the component tree based on its render method
	container.add_child(gui())

func get_components():
	return container.get_children()

func update_gui():
	var next = gui()
	Goodoo.diff(self.get_components()[0], next)

func gui():
	pass

func get_data():
	# Return the component tree as a dictionary.
	var children_data = []
	for child in get_components():
		children_data.append(child.get_data())
		
	var data = {
		"type": type,
		"input": input,
		"control": control,
		"container": container,
		"parent_control": parent_control,
		"children": children_data,
	}
	return data
