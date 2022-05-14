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
			set_properties(current.control, next.input)
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
			node.bbcode_enabled = true
			node.scroll_active = false
			node.fit_content_height = true
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
			node.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	set_properties(node, properties)
	return node


func set_properties(node:Control, properties:Dictionary) -> void:
	# Not all properties are supperted. A better way of setting properties has to be implemented.
	if properties.has("text"):
		node.text = str(properties.text)
	if properties.has("visible"):
		node.visible = properties.visible
	if properties.has("v_align"):
		if properties.v_align == "center":
			node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if properties.has("h_align"):
		if properties.h_align == "center":
			node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if properties.has("onClick"):
		node.pressed.connect(properties.onClick)
	if properties.has("clip"):
		node.clip_contents = properties.clip
	if properties.has("autowrap"):
		node.autowrap_mode = properties.autowrap
	if properties.has("onMouseEntered"):
		node.mouse_entered.connect(properties.onMouseEntered)
	if properties.has("onMouseExited"):
		node.mouse_exited.connect(properties.onMouseExited)
	if properties.has("text_submitted"):
		node.text_submitted.connect(properties.text_submitted)
	if properties.has("set"):
		node.add_theme_constant_override("margin_top", properties.set[0])
		node.add_theme_constant_override("margin_left", properties.set[1])
		node.add_theme_constant_override("margin_bottom", properties.set[2])
		node.add_theme_constant_override("margin_right", properties.set[3])
	if properties.has("onTextChanged"):
		node.text_changed.connect(properties.onTextChanged)
	if properties.has("size"):
		node.get_rect().size = properties.size
	if properties.has("expand") and properties.expand == true:
		node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
#		print("control set to expand")
#		print(node)
	if properties.has("min_size"):
		node.minimum_size = properties.min_size
	if properties.has("anchors"):
		node.anchors_preset = properties.anchors
	if properties.has("cursor"):
		if properties.cursor == "pointy hand":
			node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if properties.has("clip"):
		node.clip_contents = true
