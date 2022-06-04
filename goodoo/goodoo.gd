extends Node

# Methods to render and update the GUI.

func diff(current:Component, next:Component) -> void:
	if current.type != next.type:
		# Todo: replace the current component for the next one
		# to allow conditional rendering.
		return
		
	if not current is BasicComponent:
		# If current is CustomComponent copy the state to the next component
		# to mantain the state
		next.state = current.state
		next.complete()
	
	if current.input.hash() != next.input.hash():
		# Update the component when the input changes
		if current is BasicComponent:
			set_properties(current.control, current.input, next.input)
		else:
			var current_children = current.get_components()
			var next_children = next.get_components()
			
			for i in range(0, current.get_components().size()):
				current_children[i].input = next_children[i].input
			
		current.input = next.input
		current.updated()
	
	var current_children = current.get_components()
	var next_children = next.get_components()
	look_for_new_children(current,next)
	
	for i in range(0,  min(current_children.size(), next_children.size())):
		diff(current_children[i], next_children[i])


func look_for_new_children(current:Component, next:Component) -> void:
	# Appends new added children the the current component
	if current.get_components().size() < next.get_components().size():
		var new_children = []
		for i in range(current.get_components().size(), next.get_components().size()):
			new_children.append(next.get_components()[i])
		
		for new in new_children:
			var new_comp = new
			next.remove_child(new)
			
			if current is BasicComponent:
				current.add_child(new_comp)
				render(current.control, new_comp)
			else:
				current.container.add_child(new_comp)
				render(current.parent_control, new_comp)


func render(parent:Control, tree:Component):
	# Renders the component to the scene
	if tree is BasicComponent:
		tree.control = create_control(tree.type, tree.input)
		parent.add_child(tree.control)
		for child in tree.get_components():
			render(tree.control, child)
		tree.ready()
	else:
		tree.complete()
		tree.parent_control = parent
		for child in tree.get_components():
			render(parent, child)
		tree.ready()


func create_control(type:String, properties:Dictionary) -> Control:
	# Creates a control based on the type with the specified properties
	var node:Control
	match  type:
		"panel":
			node = PanelContainer.new()
		"vbox":
			node = VBoxContainer.new()
		"hbox":
			node = HBoxContainer.new()
		"label":
			node = Label.new()
		"rich_label":
			node = RichTextLabel.new()
		"button":
			node = Button.new()
		"control":
			node = Control.new()
		"margin":
			node = MarginContainer.new()
		"center":
			node = CenterContainer.new()
		"text_edit":
			node = TextEdit.new()
		"line_edit":
			node = LineEdit.new()
		"scroll":
			node = ScrollContainer.new()
	set_properties(node, {}, properties)
	return node


func set_properties(node:Control, last_properties, properties:Dictionary) -> void:
	for key in properties.keys():
		if key == "id": continue
		if key == "preset" and Goo.get_preset(properties[key]):
			set_preset(node,properties, last_properties)
		
		elif last_properties.has(key) and last_properties[key] == properties[key]:
			continue
			
		elif key.begins_with("on_"):
			node[key.substr(3)].connect(properties[key])
		else:
			set_property(node, properties, key)

func set_property(node, properties, key):
	if node is MarginContainer:
		if key == "const_margin_right":
			node.add_theme_constant_override("margin_right", properties[key])
		elif key == "const_margin_left":
			node.add_theme_constant_override("margin_left", properties[key])
		elif key == "const_margin_top":
			node.add_theme_constant_override("margin_top", properties[key])
		elif key == "const_margin_bottom":
			node.add_theme_constant_override("margin_bottom", properties[key])
		elif key == "const_margin_all":
			node.add_theme_constant_override("margin_right", properties[key])
			node.add_theme_constant_override("margin_left", properties[key])
			node.add_theme_constant_override("margin_top", properties[key])
			node.add_theme_constant_override("margin_bottom", properties[key])
	if key == "theme":
		node.theme = properties[key]
	elif node.get(key) != null:
		node[key] = properties[key]


func set_preset(node, properties, last_properties):
	if last_properties.has("preset"):
		if last_properties["preset"] == properties["preset"]:
			return
	var preset_props = Goo.get_preset(properties["preset"])
	for key in preset_props.keys():
		set_property(node, preset_props, key)
