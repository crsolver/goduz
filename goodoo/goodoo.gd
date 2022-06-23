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
	
	var is_child_of_container = current.control.get_parent() is Container
	
	if next_gui.type != current.type:
		var new_control = create_control(next_gui.type, next_gui.input,is_child_of_container)
		current.control.replace_by(new_control)
		next_control = new_control
		old_control.queue_free()
	else:
		set_properties(current.control, current.input, next_gui.input,is_child_of_container)
	
	for child in next.get_gui().get_children():
		render(next_control, child)
	
	next.get_parent().remove_child(next)
	next_gui.get_parent().remove_child(next_gui)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.add_child(next_gui)
	next.get_gui().control = next_control
	current.queue_free()
	await get_tree().process_frame
	next.ready()

func change_custom_for_basic(current:CustomComponent, next:BasicComponent):
	current.will_die()
	for child in current.get_gui().control.get_children():
		child.queue_free()
		
	var next_control = current.get_gui().control
	
	if current.get_gui().type != next.type:
		var old = current.get_gui().control
		var child_of_container = old.get_parent() is Container
		var new = create_control(next.type, next.input,child_of_container)
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
	current.queue_free()


func diff_basic(current:BasicComponent, next:BasicComponent):
	# Checks if a the current basicComponent has changed and updates it if that is the case.
	if current.type != next.type:
		change_basic_for_dif_basic(current, next)
		return
	elif current.input.hash() != next.input.hash():
		update_basic(current, next)
	
	var current_children = current.get_children()
	var next_children = next.get_children()
	
	for i in range(0,  current_children.size()):
		if next_children[i].type != "_omit_":
			diff(current_children[i], next_children[i])
			
	next.queue_free()


func diff_custom(current:CustomComponent, next:CustomComponent):
	if current.type != next.type:
		current.will_die()
		change_custom_for_dif_custom(current, next)
	elif current.input.hash() != next.input.hash():
		update_custom(current, next)


func change_basic_for_dif_basic(current:BasicComponent, next:BasicComponent):
	var old = current.control
	var new = create_control(next.type, next.input, old.get_parent() is Container)
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
	
	var child_of_container = old_control.get_parent() is Container
	
	if next_gui.type != current_gui.type:
		var new_control = create_control(next_gui.type, next_gui.input,child_of_container)
		current_gui.control.replace_by(new_control)
		next_control = new_control
		old_control.queue_free()
	else:
		set_properties(current_gui.control, current_gui.input, next_gui.input,child_of_container)
	
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
	await get_tree().process_frame
	next.ready()


func update_basic(current:BasicComponent, next:BasicComponent):
	var child_of_container = current.control.get_parent() is Container
	set_properties(current.control, current.input, next.input,child_of_container)
	current.input = next.input
	
	if current.list:
		update_list(current, next)


func update_list(current:BasicComponent, next:BasicComponent):
	var aux = {}
	var current_children = current.get_children()
	var next_children = next.get_children()
	
	for i in range(0, current_children.size()):
		var current_ch = current_children[i]
		if current_ch is BasicComponent:
			current.control.remove_child(current_ch.control)
		else:
			current.control.remove_child(current_ch.get_gui().control)
		current.remove_child(current_ch)
		aux[current_ch.key] = current_ch
	
	for i in range(0, next_children.size()):
		var next_ch = next_children[i]
		if aux.has(next_ch.key):
			var current_ch = aux[next_ch.key]
			current.add_child(current_ch)
			if current_ch is BasicComponent:
				current.control.add_child(current_ch.control)
			else:
				current.control.add_child(current_ch.get_gui().control)
			aux.erase(next_ch.key)
		else:
			var next_ch_children = []
			for child in next_ch.get_children():
				next_ch_children.append(child)
				next_ch.remove_child(child)
			next_ch.replace_by(BasicComponent.new({}, "_omit_", []))
			current.add_child(next_ch)
			for child in next_ch_children:
				next_ch.add_child(child)
			render(current.control, next_ch)
			
	for key in aux.keys():
		if aux[key] is BasicComponent:
			aux[key].control.queue_free()
		else:
			aux[key].will_die()
			aux[key].get_gui().control.queue_free()
		aux[key].queue_free()


func update_custom(current:CustomComponent, next:CustomComponent):
	current.input = next.input
	next.state = current.state
	next.complete()
	diff(current.get_gui(), next.get_gui())
	next.queue_free()
	await get_tree().process_frame
	current.updated()


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
		component.control = create_control(component.type, component.input, parent is Container)
		parent.add_child(component.control)
		for child in component.get_children():
			render(component.control, child)
	else:
		component.complete()
		component.parent_control = parent
		render(parent, component.get_gui())
		await get_tree().process_frame
		component.ready()


func create_control(type:String, properties:Dictionary,child_of_container) -> Control:
	# Creates a control based on the type with the specified properties
	var node:Control
	match  type:
		"control"        :node = Control.new()
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
		
	set_properties(node, {}, properties, child_of_container)
	return node


func set_properties(node:Control, last_properties, properties:Dictionary,child_of_container) -> void:
	for key in properties.keys():
		if key == "id": continue
		if key == "key": continue
		if key == "list": continue
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
					set_preset(node,preset,child_of_container)
		
		elif last_properties.has(key) and last_properties[key] == properties[key]:
			continue
			
		elif key.begins_with("on_"):
			node[key.substr(3)].connect(properties[key])
		else:
			set_property(node, properties, key, child_of_container)

func set_property(node:Control, properties:Dictionary, key:String, child_of_container) -> void:
	if child_of_container and (key.begins_with("anchor") or key.begins_with("offset") or key=="layout_mode"):
		return
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


func set_preset(node:Control, preset:String,child_of_container) -> void:
	var preset_props = Goo.get_preset(preset)
	for key in preset_props.keys():
		set_property(node, preset_props, key,child_of_container)
