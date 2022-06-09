extends Node

# Methods to render and update the GUI.

func diff(current:Component, next:Component) -> void:
	if current is BasicComponent:
		if next is BasicComponent:
			diff_basic(current, next)
		else:
			change_basic_for_custom(current, next)
	else:
		if not next is BasicComponent: 
			diff_custom(current, next)
		else:
			change_custom_for_basic(current, next)


func change_basic_for_custom(current:BasicComponent, next:CustomComponent):
	next.complete()
	var next_control
	var next_gui = next.get_gui()
	
	var old_control = current.control
	next_control = old_control
	
	var c_parent = current.control.get_parent()
	
	for child in old_control.get_children():
		child.queue_free()
	
	if next_gui.type != current.type:
		var new_control = create_control(next_gui.type, next_gui.input)
		current.control.replace_by(new_control)
		next_control = new_control
		old_control.queue_free()
	else:
		set_properties(current.control, current.input, next_gui.input)
	#current.input = next_gui.input
	
	for child in next.get_gui().get_children():
		render(next_control, child)
	
	next.get_parent().remove_child(next)
	next_gui.get_parent().remove_child(next_gui)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.add_child(next_gui)
	next.get_gui().control = next_control
	current.queue_free()

func change_custom_for_basic(current:CustomComponent, next:BasicComponent):
	
	for child in current.get_gui().control.get_children():
		child.queue_free()
		
	var next_control = current.get_gui().control
	
	if current.get_gui().type != next.type:
		var old = current.get_gui().control
		var new = create_control(next.type, next.input)
		current.get_gui().control.replace_by(new)
		old.queue_free()
		next_control = new
	elif current.input.hash() != next.input.hash():
		update_basic(current.get_gui(), next)
	
	for child in next.get_children():
		render(current.get_gui().control, child)
	
	
	next.get_parent().remove_child(next)
	current.container.free()
	current.control.free()
	current.replace_by(next)
	next.control = next_control
	print("next basic childre ")
	for child in next.get_children():
		print(child)
	print("__________fin next basic children")
	current.queue_free()


func diff_basic(current:BasicComponent, next:BasicComponent):
	if current.type != next.type:
		change_basic_for_dif_basic(current, next)
		return
	elif current.input.hash() != next.input.hash():
		update_basic(current, next)
	
	var current_children = current.get_children()
	var next_children = next.get_children()
	look_for_new_children(current,next)
	
	for i in range(0,  min(current_children.size(), next_children.size())):
		diff(current_children[i], next_children[i])
	next.queue_free()


func diff_custom(current:CustomComponent, next:CustomComponent):
	if current.type != next.type:
		change_custom_for_dif_custom(current, next)
	elif current.input.hash() != next.input.hash():
		update_custom(current, next)


func change_basic_for_dif_basic(current:BasicComponent, next:BasicComponent):
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


func change_custom_for_dif_custom(current:CustomComponent, next:CustomComponent):
	next.complete()
	var next_control
	
	var current_gui = current.get_gui()
	var next_gui = next.get_gui()
	
	var old_control = current_gui.control
	next_control = old_control
	
	for child in old_control.get_children():
		child.queue_free()
	
	if next_gui.type != current_gui.type:
		var new_control = create_control(next_gui.type, next_gui.input)
		current_gui.control.replace_by(new_control)
		next_control = new_control
		old_control.queue_free()
	else:
		set_properties(current_gui.control, current_gui.input, next_gui.input)
	
	for child in next.get_gui().get_children():
		render(next_control, child)
	
	var c_parent = current.parent_control
	var container = current.container
	
	next.get_parent().remove_child(next)
	next_gui.get_parent().remove_child(next_gui)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.add_child(next_gui)
	next.get_gui().control = next_control
	container.free()
	current.control.free()
	current.free()


func update_basic(current:BasicComponent, next:BasicComponent):
	set_properties(current.control, current.input, next.input)
	current.input = next.input


func update_custom(current:CustomComponent, next:CustomComponent):
	current.input = next.input
	next.state = current.state
	next.complete()
	diff(current.get_gui(), next.get_gui())
	current.updated()
	next.queue_free()


func look_for_new_children(current:BasicComponent, next:BasicComponent) -> void:
	# Appends new added children the the current component
	if current.get_children().size() < next.get_children().size():
		var new_children = []
		for i in range(current.get_children().size(), next.get_children().size()):
			new_children.append(next.get_children()[i])
		
		for new in new_children:
			var new_comp = new
			next.remove_child(new)
			
			if current is BasicComponent:
				current.add_child(new_comp)
				render(current.control, new_comp)
			else:
				current.container.add_child(new_comp)
				render(current.parent_control, new_comp)


func render(parent:Control, component:Component) -> void:
	# Renders the component to the scene
	if component is BasicComponent:
		component.control = create_control(component.type, component.input)
		parent.add_child(component.control)
		for child in component.get_children():
			render(component.control, child)
	else:
		component.complete()
		component.parent_control = parent
		render(parent, component.get_gui())
		component.ready()


func create_control(type:String, properties:Dictionary) -> Control:
	# Creates a control based on the type with the specified properties
	var node:Control
	match  type:
		"container"      :node = PanelContainer.new()
		"aspect_radio"   :node = AspectRatioContainer.new()
		"center"         :node = CenterContainer.new()
		"hbox"           :node = HBoxContainer.new()
		"vbox"           :node = VBoxContainer.new()
		"graphnode"      :node = GraphNode.new()
		"grid"           :node = GridContainer.new()
		"hflow"          :node = HFlowContainer.new()
		"vflow"          :node = VFlowContainer.new()
		"hsplit"         :node = HSplitContainer.new()
		"vsplit"         :node = VSplitContainer.new()
		"margin"         :node = MarginContainer.new()
		"panel_container":node = PanelContainer.new()
		"scrollbox"      :node = ScrollContainer.new()
		"subviewport"    :node = SubViewportContainer.new()
		"tabbox"         :node = TabContainer.new()
		"button"         :node = Button.new()
		"link_button"    :node = LinkButton.new()
		"texture_button" :node = TextureButton.new()
		"text_edit"      :node = TextEdit.new()
		"code_edit"      :node = CodeEdit.new()
		"color_rect"     :node = ColorRect.new()
		"graph_edit"     :node = GraphEdit.new()
		"vscrollbar"     :node = VScrollBar.new()
		"hscrollbar"     :node = VScrollBar.new()
		"vslider"        :node = VSlider.new()
		"hslider"        :node = HSlider.new()
		"progressbar"    :node = ProgressBar.new()
		"spinbox"        :node = SpinBox.new()
		"texture_progress_bar":node = TextureProgressBar.new()
		"hseparator"     :node = HSeparator.new()
		"vseparator"     :node = VSeparator.new()
		"item_list"      :node = ItemList.new()
		"label"          :node = Label.new()
		"line_edit"      :node = LineEdit.new()
		"nine_patch_rect":node = NinePatchRect.new()
		"panel"          :node = Panel.new()
		"reference_rect" :node = ReferenceRect.new()
		"rich_label"     :node = RichTextLabel.new()
		"tab_bar"        :node = TabBar.new()
		"texture_rect"   :node = TextureRect.new()
		"tree"           :node = Tree.new()
		
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
