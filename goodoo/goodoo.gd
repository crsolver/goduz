extends Node

# Methods to render and update the GUI.

func diff(current:Component, next:Component) -> void:
	print("___________________________-")
	if current.type != next.type:
		if current is BasicComponent:
			change_basic_for_dif_basic(current, next)
			return
		else:
			change_custom_for_dif_custom(current, next)
			print("after:")
			print(Utils.dict_to_json(next.get_data()))
			return
	# BasicComponent
	if current is BasicComponent:
		if current.input.hash() != next.input.hash():
			update_basic(current, next)
			
		var current_children = current.get_components()
		var next_children = next.get_components()
		look_for_new_children(current,next)
			
		for i in range(0,  min(current_children.size(), next_children.size())):
			diff(current_children[i], next_children[i])
#		current.updated()
		next.queue_free()
	# CustomComponent
	else:
		next.state = current.state
		next.complete()
		if current.input.hash() != next.input.hash():
			update_custom(current, next)
		next.queue_free()

func change_basic_for_dif_basic(current:Component, next:Component):
	print("changing basic for a diferent basic")
	var old = current.control
	var new = create_control(next.type, next.input)
	current.control.replace_by(new)
	current.control = new
	old.queue_free()
	current.input = next.input
	current.type = next.type
	for child in next.get_children():
		next.remove_child(child)
		add_child(child)
	next.queue_free()


func change_custom_for_dif_custom(current:Component, next:Component):
	print("before:")
	print(Utils.dict_to_json(current.get_data()))
	
	var next_control
	var direct_child = current.get_components()[0]
	next.complete()
	var next_direct_child = next.get_components()[0]
	
	var old_control = direct_child.control
	next_control = old_control
	
	for child in old_control.get_children():
		child.queue_free()
		
	if next_direct_child.type != direct_child.type:
		var new_control = create_control(next_direct_child.type, next_direct_child.input)
		direct_child.control.replace_by(new_control)
		old_control.queue_free()
		next_control = new_control
	else:
		set_properties(direct_child.control, direct_child.input, next_direct_child.input)
	
	for child in next.get_components()[0].get_children():
		print("rendering " + child.type)
		render(next_control, child)
	
	var c_parent = current.parent_control
	next.get_parent().remove_child(next)
	var delete = current
	var container = current.container
	var next_children = next.get_components()[0]
	next_children.get_parent().remove_child(next_children)
	var children = container.get_children()[0]
	container.remove_child(children)
	children.queue_free()
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.queue_free()
	next.extras.queue_free()
	#re
	next.container = container
	next.container.add_child(next_children)
	next.get_components()[0].control = next_control
	
	delete.queue_free()
	current.queue_free()
	print("updated direct_child.control " + str(direct_child.control))


func update_basic(current, next):
	set_properties(current.control, current.input, next.input)
	current.input = next.input

func update_custom(current, next):
	var current_children = current.get_components()
	var next_children = next.get_components()
	
	for i in range(0, current.get_components().size()):
		diff(current_children[i], next_children[i])
		current_children[i].input = next_children[i].input
		
	current.input = next.input
	current.updated()

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


func render(parent:Control, tree:Component) -> void:
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
	print("creating a " + type)
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
		if key == "preset":
			if last_properties.has("preset"):
				if last_properties["preset"] == properties["preset"]:
					return
			var presets = properties.preset.split(" ")
			var last_p = []
			if last_properties.has("preset"):
				last_p = last_properties.preset.split(" ")
			for preset in presets:
				if last_p.count(preset) > 0: continue
				if Goo.get_preset(preset):
					set_preset(node,preset)
		
		elif last_properties.has(key) and last_properties[key] == properties[key]:
			continue
			
		elif key.begins_with("on_"):
			node[key.substr(3)].connect(properties[key])
		else:
			set_property(node, properties, key)

func set_property(node:Control, properties:Dictionary, key:String) -> void:
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


func set_preset(node:Control, preset:String) -> void:
	var preset_props = Goo.get_preset(preset)
	for key in preset_props.keys():
		set_property(node, preset_props, key)
