extends Node
# Author: Andres Gamboa


# Methods to render and update the view.

func diff(current:BaseComponent, next:BaseComponent) -> void:
	if current is BasicComponent and next is BasicComponent:
		diff_basic(current, next)
		
	elif current is BasicComponent and not next is BasicComponent:
		change_basic_for_custom(current, next)
		
	elif not (current is BasicComponent and next is BasicComponent): 
		diff_custom(current, next)
		
	elif not current is BasicComponent and next is BasicComponent:
		change_custom_for_basic(current, next)


func change_basic_for_custom(current:BasicComponent, next:Component) -> void:
	next.complete()
	var next_control
	var next_view = next.get_view()
	
	var old_control = current.control
	next_control = old_control
	
	var c_parent = current.control.get_parent()
	
	for child in old_control.get_children():
		child.queue_free()
	
	var is_child_of_container = current.control.get_parent() is Container
	
	if next_view.type != current.type:
		var new_control = create_control(next_view.type, next_view.props,is_child_of_container)
		current.control.replace_by(new_control)
		next_control = new_control
		old_control.queue_free()
	else:
		set_properties(current.control, current.props, next_view.props,is_child_of_container)
	
	for child in next.get_view().get_children():
		render(next_control, child)
	
	next.get_parent().remove_child(next)
	next_view.get_parent().remove_child(next_view)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.add_child(next_view)
	next.get_view().control = next_control
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()

func change_custom_for_basic(current:Component, next:BasicComponent) -> void:
	current.component_will_die()
	
	for child in current.get_view().control.get_children():
		child.queue_free()
	
	var next_control = current.get_view().control
	
	if current.get_view().type != next.type:
		var old = current.get_view().control
		var child_of_container = old.get_parent() is Container
		var new = create_control(next.type, next.props,child_of_container)
		
		if old is ScrollContainer:
			old.get_h_scroll_bar().queue_free()
			old.get_v_scroll_bar().queue_free()
		
		current.get_view().control.replace_by(new)
		old.queue_free()
		next_control = new
		
	elif current.props.hash() != next.props.hash():
		update_basic(current.get_view(), next)
	
	for child in next.get_children():
		render(current.get_view().control, child)
	
	next.get_parent().remove_child(next)
	current.container.free()
	current.control.free()
	current.replace_by(next)
	next.control = next_control
	current.queue_free()

# Checks if a the current BasicComponent has changed and updates it if that is the case.
func diff_basic(current:BasicComponent, next:BasicComponent) -> void:
	if current.type != next.type:
		change_basic_for_dif_basic(current, next)
		return
	elif current.props.hash() != next.props.hash():
		update_basic(current, next)
	
	var current_children = current.get_children()
	var next_children = next.get_children()
	
	# Can the children be checked with threads?
	for i in range(0,  current_children.size()):
		if next_children[i].type != "_omit_":
			diff(current_children[i], next_children[i])
			
	next.queue_free()


func diff_custom(current:Component, next:Component) -> void:
	if current.type != next.type:
		current.component_will_die()
		change_custom_for_dif_custom(current, next)
	elif current.props.hash() != next.props.hash():
		update_custom(current, next)


func change_basic_for_dif_basic(current:BasicComponent, next:BasicComponent) -> void:
	var old = current.control
	var new = create_control(next.type, next.props, old.get_parent() is Container)
	
	for child in old.get_children():
		child.queue_free()
	
	current.control.replace_by(new)
	current.control = new
	old.queue_free()
	current.props = next.props
	current.type = next.type
	
	for child in next.get_children():
		next.remove_child(child)
		add_child(child)
	
	next.queue_free()


func change_custom_for_dif_custom(current:Component, next:Component) -> void:
	next.complete()
	var next_control
	var current_view = current.get_view()
	var next_view = next.get_view()
	
	var old_control = current_view.control
	next_control = old_control
	
	for child in old_control.get_children():
		child.queue_free()
	
	var child_of_container = old_control.get_parent() is Container
	
	var new_control = create_control(next_view.type, next_view.props,child_of_container)
	current_view.control.replace_by(new_control)
	next_control = new_control
	old_control.queue_free()
	
	for child in next.get_view().get_children():
		render(next_control, child)
	
	var c_parent = current.parent_control
	var container = current.container
	
	next.get_parent().remove_child(next)
	next_view.get_parent().remove_child(next_view)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.container.add_child(next_view)
	next.get_view().control = next_control
	container.queue_free()
	current.control.queue_free()
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()


func update_basic(current:BasicComponent, next:BasicComponent) -> void:
	var child_of_container = current.control.get_parent() is Container
	set_properties(current.control, current.props, next.props,child_of_container)
	current.props = next.props
	
	if current.list != null:
		update_list(current, next)


# Naive solution. A better implementation is needed.
func update_list(current:BasicComponent, next:BasicComponent) -> void:
	var aux = {}
	var current_children = current.get_children()
	var next_children = next.get_children()
	
	# Remove the items (control nodes) and save the components in aux
	for i in range(0, current_children.size()):
		var current_ch = current_children[i]
		if current_ch is BasicComponent:
			current.control.remove_child(current_ch.control)
		else:
			current.control.remove_child(current_ch.get_view().control)
		current.remove_child(current_ch)
		aux[current_ch.key] = current_ch
	
	# Add the items in the new order
	# Add new items
	# Delete items that are not in the updated version
	for i in range(0, next_children.size()):
		var next_ch = next_children[i]
		if aux.has(next_ch.key):
			# Add an old item in its new position
			var current_ch = aux[next_ch.key]
			current.add_child(current_ch)
			if current_ch is BasicComponent:
				current.control.add_child(current_ch.control)
			else:
				current.control.add_child(current_ch.get_view().control)
			aux.erase(next_ch.key)
		else:
			# Add a new item
			var next_ch_children = []
			for child in next_ch.get_children():
				next_ch_children.append(child)
				next_ch.remove_child(child)
			# this component is new. omit when checking for changes
			next_ch.replace_by(BasicComponent.new({}, "_omit_", []))
			current.add_child(next_ch)
			for child in next_ch_children:
				next_ch.add_child(child)
			render(current.control, next_ch)
			
	# Delete items
	for key in aux.keys():
		if aux[key] is BasicComponent:
			aux[key].control.queue_free()
		else:
			aux[key].component_will_die()
			aux[key].get_view().control.queue_free()
		aux[key].queue_free()


func update_custom(current:Component, next:Component) -> void:
	current.props = next.props
	next.state = current.state
	next.complete()
	diff(current.get_view(), next.get_view())
	next.queue_free()
	await get_tree().process_frame
	current.component_updated()

# Renders the component to the scene
func render(parent:Control, component:BaseComponent) -> void:
	if component is BasicComponent: 
		component.control = create_control(component.type, component.props, parent is Container)
		parent.add_child(component.control)
		for child in component.get_children():
			render(component.control, child)
	else:
		component.complete()
		component.parent_control = parent
		render(parent, component.get_view())
		await get_tree().process_frame
		component.component_ready()


func create_control(type:String, properties:Dictionary,child_of_container) -> Control:
	# Creates a control based on the type with the specified properties
	var node:Control
	match  type:
		"control"        :node = Control.new()
		"panel_container"      :node = PanelContainer.new()
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
		"panel":         node = Panel.new()
		"scrollbox"      :node = ScrollContainer.new()
		"subviewport"    :
			node = SubViewportContainer.new()
			node.add_child(SubViewport.new())
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
					continue
			var presets = properties.preset.split(" ")
			var last_p = []
			if last_properties.has("preset"):
				last_p = last_properties.preset.split(" ")
			for preset in presets:
				if last_p.count(preset) > 0: continue
				if Gui.get_preset(preset):
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
	if properties[key] is Resource:
		node[key] = properties[key]
	elif node.get(key) != null:
		node[key] = properties[key]


func set_preset(node:Control, preset:String,child_of_container) -> void:
	var preset_props = Gui.get_preset(preset)
	for key in preset_props.keys():
		set_property(node, preset_props, key,child_of_container)
