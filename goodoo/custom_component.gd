extends Component

class_name CustomComponent

var state:Dictionary
var container
var parent_control

func _init(_type, _input={}):
	type = _type
	input = _input
	control = Node.new()
	container = Node.new()
	add_child(control)
	add_child(container)

func complete():
	# creates the component tree based on its render method
	container.add_child(gui())

func get_components():
	return container.get_children()

func update_gui():
	var next = gui()
	Goodoo.diff(self.get_components()[0], next)
	next.queue_free()

func gui():
	pass
