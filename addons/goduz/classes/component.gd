class_name Component extends BaseComponent


var state: Dictionary
var key = null
var component_owner

func _init(_props:Dictionary={}) -> void:
	state = {}
	type = get_script().get_path()
	props = _props.duplicate(true)
	if props.has("key"):
		key = props.key

# __________________
# Completes the tree of the component.
func complete() -> void:
	add_child(view())

# The representation of the Graphical User Interface (the view composed of control nodes) of the component.
# Similar to render function in React.
# It generates a tree structure (similar to the Virtual Dom in React) that will be use to render 
# the component the first time and to generate updated versions that can be used to update what has been changed.

func view(): # -> BasicComponent:
	pass

func get_view() -> BasicComponent:
	return get_children()[0]


# Compares the current view of the component agains the updated view to make the necessary changes to control nodes.
func update_view() -> void:
	Goduz.diff(get_view(), view())


# Lifecycle methods
func component_ready():
	pass

func component_updated():
	pass

func component_will_die():
	pass

func delete():
	component_will_die()
	get_view().control_node.queue_free()
#	var p = get_parent()
#	if p:
#		p.remove_child(self)
	queue_free()

#func include(node:Node):
#	control_node.add_child(node)

# Does work
func call_method(method, args: Array = []):
	var obj = method.get_object()
	method.callv(args)
	obj.update_view()





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

func connect_signal(control_signal, function:Callable):
#	if function.is_custom(): # [ ] This could cause a problem with lambda arguments
#		control_signal.connect(_call_function.bind(function))
#		return
	var args_count = _get_method_args_count(function.get_method())
	match args_count:
		0: control_signal.connect(_call_function.bind(function))
		1: control_signal.connect(_call_function_one_arg.bind(function))
		2: control_signal.connect(_call_function_two_arg.bind(function))
		3: control_signal.connect(_call_function_three_arg.bind(function))
		4: control_signal.connect(_call_function_four_arg.bind(function))
		5: control_signal.connect(_call_function_five_arg.bind(function))

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
			return _gui.control_node
	return _gui.get_control(id)


func nothing() -> BasicComponent:
	return BasicComponent.new({}, "control", [])

func show_if(show: bool, child) -> BasicComponent:
	if show:
		return child
	child.queue_free()
	return BasicComponent.new({}, "control", [])


func control(properties:Dictionary={}, children=[]) -> BasicComponent:
	return BasicComponent.new(properties, "control", children)

func box(properties:Dictionary={}, children=[]) -> BasicComponent:
	return BasicComponent.new(properties, "box", children)

# Containers
func container(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"container", children)

func aspect_radio(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"aspect_radio_container", children)

func center(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"center", children)

func hbox(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties, "hbox", children)

func vbox(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties, "vbox", children)

func graphnode(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"graphnode", children)

func grid(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"grid", children)

func hflow(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"hflow", children)

func vflow(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"vflow", children)

func hsplit(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"hsplit", children)

func vsplit(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"vsplit", children)

func margin(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"margin", children)

func panel_container(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"panel_container", children)

func scrollbox(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"scrollbox", children)

func subviewport(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"subviewport", children)

func tabbox(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"tabbox", children)


# Buttons

func button(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"button", children)

func link_button(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"link_button", [])

func texture_button(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"texture_button", [])

func text_edit(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"text_edit", [])

func code_edit(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"code_edit", [])

func color_rect(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"color_rect", [])

func color_picker(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"color_picker", [])

func graph_edit(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"graph_edit", [])

func hscrollbar(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"vscrollbar", [])

func vscrollbar(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"vscrollbar", [])

func vslider(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"vslider", [])

func hslider(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"hslider", [])

func progressbar(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"progressbar", [])

func spinbox(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"spinbox", [])

func texture_progress_bar(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"texture_progress_bar", [])

func vseparator(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"vseparator", [])
	
func hseparator(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"hseparator", [])

func item_list(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"item_list", [])

func label(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"label", [])

func line_edit(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"line_edit", [])

func nine_patch_rect(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"nine_patch_rect", [])

func panel(properties:Dictionary={},children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"panel", children)

func reference_rect(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"reference_rect", [])
	
func rich_label(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"rich_label", [])	

func tab_bar(properties:Dictionary={}, children:Array=[]) -> BasicComponent:
	return BasicComponent.new(properties,"tab_bar", children)

func texture_rect(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"texture_rect", [])

func tree(properties:Dictionary={}) -> BasicComponent:
	return BasicComponent.new(properties,"tree", [])
