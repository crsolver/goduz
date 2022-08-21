class_name Component extends BaseComponent
# Author: Andres Gamboa

var owner_component
var state: Dictionary = {}
# Setter not working as expected, it used to work on alpha 10
#	get:
#		return state
#	set(value):
#		var update = state != {}
#		state = value
#		if update: update_view()

var container
var parent_control
var key = null
var expression

func _init(_type:String, _props:Dictionary={}):
	type = _type
	props = _props.duplicate(true)
	if props.has("key"):
		key = props.key
	control = Node.new()
	container = Node.new()
	add_child(control)
	add_child(container)

# __________________
# Completes the tree of the component.
func complete() -> void:
	expression = Expression.new()
	container.add_child(view())

# The representation of the Graphical User Interface (the view composed of control nodes) of the component.
# Similar to render function in React.
# It generates a tree structure (similar to the Virtual Dom in React) that will be use to render 
# the component the first time and to generate updated versions that can be used to update what has been changed.

func view(): # -> BasicComponent:
	pass

func get_view() -> BasicComponent:
	return container.get_children()[0]


# Compares the current gui of the component agains the updated gui to make the necessary changes to control nodes.
func update_view() -> void:
	Goduz.diff(self.get_view(), view())


# Lifecycle methods
func component_ready():
	pass

func component_updated():
	pass

func component_will_die():
	pass


# For Debug porpuses
#func get_data():
#	# Return the component tree as a dictionary.
#	var data = {
#		"type": type,
#		"props": props,
#		"control": control,
#		"container": container,
#		"parent_control": parent_control,
#		"children": get_view().get_data(),
#	}
#	return data
func _get_method_args_count(method_name):
	var method_list = get_method_list()
	for m in method_list:
		if m.name == method_name:
			return m.args.size()

func connect_func_to_signal(func_name, control:Control, signal_name):
	var args_count = _get_method_args_count(func_name)
	match args_count:
		0: control.connect(signal_name, _call_function, [func_name])
		1: control.connect(signal_name, _call_function_one_arg, [func_name])
		2: control.connect(signal_name, _call_function_two_arg, [func_name])
		3: control.connect(signal_name, _call_function_three_arg, [func_name])
		4: control.connect(signal_name, _call_function_four_arg, [func_name])
		5: control.connect(signal_name, _call_function_five_arg, [func_name])

func _call_function(function) -> void:
	var expression = Expression.new()
	expression.parse(function+"()", [])
	expression.execute([], self)
	update_view()

func _call_function_one_arg(one, function) -> void:
	var expression = Expression.new()
	expression.parse(function+"(one)", ["one"])
	expression.execute([one], self)
	update_view()

func _call_function_two_arg(one, two, function) -> void:
	expression.parse(function+"(one, two)", ["one", "two"])
	expression.execute([one, two], self)
	update_view()

func _call_function_three_arg(one, two, three, function) -> void:
	expression.parse(function+"(one, two, three)", ["one", "two", "three"])
	expression.execute([one, two, three], self)
	update_view()

func _call_function_four_arg(one, two, three, four, function) -> void:
	expression.parse(function+"(one, two, three, four)", ["one", "two", "three", "four"])
	expression.execute([one, two, three, four], self)
	update_view()

func _call_function_five_arg(one, two, three, four, five, function) -> void:
	expression.parse(function+"(one, two, three)", ["one", "two", "three", "four", "five"])
	expression.execute([one, two, three, four, five], self)
	update_view()

func get_control(id) -> Control:
	var _gui = get_view()
	if _gui.props.has("id"):
		if _gui.props.id == id:
			return _gui.control
	return _gui.get_control(id)
