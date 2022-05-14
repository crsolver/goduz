extends Component

class_name CustomComponent

var state:Dictionary
var container
var parent_control

func _init(_input={}):
	type = "custom"
	input = _input
	control = Node.new()
	container = Node.new()
	add_child(control)
	add_child(container)


func complete():
	# creates the component tree based on its render method
	container.add_child(render())

func get_components():
	return container.get_children()


func set_state(value:Dictionary):
	if state.hash() == value.hash():
		return
	state = value
#	print("_______________________________________")
#	print("current")
#	print(Utils.dict_to_json(get_components()[0].get_data()))
	var new_tree = render()
#	print("next")
#	print(Utils.dict_to_json(new_tree.get_data()))
	Goodoo.diff(self.get_components()[0], new_tree)
	new_tree.queue_free()

func render():
	pass
