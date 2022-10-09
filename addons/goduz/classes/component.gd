class_name Component extends BaseComponent

var owner_component
var state: Dictionary = {}


var container
var parent_control
var key = null
var expression

func _init(_props:Dictionary={}):
	type = get_script().get_path()
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


# Compares the current view of the component agains the updated view to make the necessary changes to control nodes.
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


# signals are connected to a fuction that call the desired function and then call update_view()
# to keep the control nodes in sync with the state, this eliminates the need to call update_view() manually.

func connect_func_to_signal(function:Callable, control:Control, signal_name):
	if function.is_custom(): # [ ] This could cause a problem with lambda arguments
		control[signal_name].connect(_call_function.bind(function))
		return
	var args_count = _get_method_args_count(function.get_method())
	match args_count:
		0: control[signal_name].connect(_call_function.bind(function))
		0: control[signal_name].connect(_call_function_one_arg.bind(function))
		0: control[signal_name].connect(_call_function_two_arg.bind(function))
		0: control[signal_name].connect(_call_function_three_arg.bind(function))
		0: control[signal_name].connect(_call_function_four_arg.bind(function))
		0: control[signal_name].connect(_call_function_five_arg.bind(function))

func _call_function(function) -> void:
	function.call()
	update_view()

func _call_function_one_arg(one, function) -> void:
	function.call(one)
	update_view()

func _call_function_two_arg(one, two, function) -> void:
	function.call(one, two)
	update_view()

func _call_function_three_arg(one, two, three, function) -> void:
	function.call(one, two, three)
	update_view()

func _call_function_four_arg(one, two, three, four, function) -> void:
	function.call(one, two, three, four)
	update_view()

func _call_function_five_arg(one, two, three, four, five, function) -> void:
	function.call(one, two, three, four, five)
	update_view()

func _get_method_args_count(method_name):
	var method_list = get_method_list()
	for m in method_list:
		if m.name == method_name:
			return m.args.size()

func get_control(id) -> Control:
	var _gui = get_view()
	if _gui.props.has("id"):
		if _gui.props.id == id:
			return _gui.control
	return _gui.get_control(id)
