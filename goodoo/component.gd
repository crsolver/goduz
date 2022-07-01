extends BaseComponent

class_name Component

var state:Dictionary
var container
var parent_control
var key = null

func _init(_type:String, _input:Dictionary={}):
	type = _type
	input = _input.duplicate(true)
	if input.has("key"):
		key = input.key
	control = Node.new()
	container = Node.new()
	add_child(control)
	add_child(container)

# __________________
# Completes the tree of the component.
func complete():
	container.add_child(gui())

# The representation of the Graphical User Interface (the view composed of control nodes) of the component.
# Similar to render function in React.
# It generates a tree structure (similar to the Virtual Dom in React) that will be use to render 
# the component the first time and to generate updated versions that can be used to update what has been changed.

func gui(): # -> BasicComponent:
	pass

func get_gui():
	return container.get_children()[0]


# Compares the current gui of the component agains the updated gui to make the necessary changes to control nodes.
func update_gui():
	Goodoo.diff(self.get_gui(), gui())


# Lifecycle methods
func ready():
	pass

func updated():
	pass

func will_die():
	pass


# For Debug porpuses
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
