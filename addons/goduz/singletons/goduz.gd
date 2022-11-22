extends Node
# Methods to render and update the view.

@onready
var box_scene = preload("res://addons/goduz/custom_controls/box.tscn")

# To do
# [ ] Fix: Lambdas cause unnecesary updates in control nodes (they are created every time view() is called causing the props to be different)


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
	
	var old_control = current.control_node
	next_control = old_control
	
	var c_parent = current.control_node.get_parent()
	
	for child in old_control.get_children():
		child.queue_free()
	
	var is_child_of_container = current.control_node.get_parent() is Container
	
	var new_control = create_control(current.component_owner, next_view.type, next_view.props,is_child_of_container)
	current.control_node.replace_by(new_control)
	next_control = new_control
	old_control.queue_free()
	
	for child in next.get_view().get_children():
		render(next_control, child, current.component_owner)
	
	next.get_parent().remove_child(next)
	next_view.get_parent().remove_child(next_view)
	
	current.replace_by(next)
	next.add_child(next_view)
	next.get_view().control_node = next_control
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()


func change_custom_for_basic(current:Component, next:BasicComponent) -> void:
	current.component_will_die()
	
	for child in current.get_view().control_node.get_children():
		child.queue_free()
	
	var next_control = current.get_view().control_node
	
	var old = current.get_view().control_node
	
	var new = create_control(
		current.component_owner, 
		next.type, 
		next.props,
		old.get_parent() is Container
	)
	
	if old is ScrollContainer:
		old.get_h_scroll_bar().queue_free()
		old.get_v_scroll_bar().queue_free()
	
	current.get_view().control_node.replace_by(new)
	old.queue_free()
	next_control = new
	
	
	for child in next.get_children():
		render(current.get_view().control_node, child, current.component_owner)
	
	next.get_parent().remove_child(next)
	current.replace_by(next)
	next.control_node = next_control
	current.queue_free()

# Checks if a the current BasicComponent has changed and updates it if that is the case.
func diff_basic(current:BasicComponent, next:BasicComponent) -> void:
	if current.type != next.type:
		change_basic_for_dif_basic(current, next)
		return
	elif current.props.hash() != next.props.hash():
		update_basic(current, next)
	
	if current.list: 
		return
	
	var current_children = current.get_children()
	var next_children = next.get_children()
	
	# Can the children be checked with threads?
	for i in range(0,  current_children.size()):
		if i < next_children.size():
			diff(current_children[i], next_children[i])
			
	next.queue_free()


func diff_custom(current:Component, next:Component) -> void:
	if current.type != next.type:
		current.component_will_die()
		change_custom_for_dif_custom(current, next)
	elif current.props.hash() != next.props.hash():
		update_custom(current, next)


func change_basic_for_dif_basic(current:BasicComponent, next:BasicComponent) -> void:
	var old = current.control_node
	
	for child in old.get_children():
		child.queue_free()
		
	var new = create_control(
		current.component_owner, 
		next.type, next.props, 
		old.get_parent() is Container
	)
	
	current.control_node.replace_by(new)
	current.control_node = new
	
	old.queue_free()
	
	current.props = next.props
	current.type = next.type
	
	for child in next.get_children():
		next.remove_child(child)
		add_child(child)
	
	next.queue_free()


func change_custom_for_dif_custom(current:Component, next:Component) -> void:
	next.complete()
	var current_control = current.get_view().control_node
	
	for child in current_control.get_children():
		child.queue_free()
	
	var next_control = create_control(
		current.component_owner, 
		next.get_view().type, 
		next.get_view().props,
		current_control.get_parent() is Container
	)
	
	current.get_view().control_node.replace_by(next_control)
	current_control.queue_free()
	
	for child in next.get_view().get_children():
		render(next_control, child, current.component_owner)
	
	
	next.get_parent().remove_child(next)
	next.get_view().get_parent().remove_child(next.get_view())
	
	current.replace_by(next)
	next.add_child(next.get_view())
	next.get_view().control_node = next_control
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()


func update_basic(current:BasicComponent, next:BasicComponent) -> void:
	set_properties(
		current.component_owner, 
		current.control_node, 
		current.props, 
		next.props,
		current.control_node.get_parent() is Container,
		true
	)
	current.props = next.props
	
	if current.list != null:
		update_list(current, next)

enum {
	DIFF,
	MOVE,
	ADD_AT,
	ADD,
	DELETE
}


func update_list(current:BasicComponent, next:BasicComponent) -> void:
	var current_size = current.get_child_count()
	var next_size = next.get_child_count()
	var end = max(current_size, next_size)
	var c_aux = {}
	var n_aux = {}
	
	for i in range(0, end):
		var child
		if i < current_size:
			child = current.get_child(i)
			c_aux[child.key] = child
		if i < next_size:
			child = next.get_child(i)
			n_aux[child.key] = child
			
	var i = 0
	var operation = ""
	
	while i < max(current.get_child_count(), next.get_child_count()):
		var current_item = null
		var next_item = null
		
		if i < current.get_child_count(): 
			current_item = current.get_child(i)
		
		if i < next.get_child_count(): 
			next_item = next.get_child(i)
		
		if next_item and current_item:
			# Items are the same, look for changes
			if next_item.key == current_item.key:
				operation = DIFF
			elif n_aux.has(current_item.key): # next.find(func(item):return item.key == current_item.key) # n_aux.has(current_item.key):
				if c_aux.has(next_item.key):
					operation = MOVE
				else:
					operation = ADD_AT
			else:
				operation = DELETE
		elif next_item and not current_item:
			operation = ADD
		elif not next_item and current_item:
			operation = DELETE
		else:
			return
		
		match(operation):
			DIFF:
				diff(current_item, next_item)
				
			MOVE:
				if next_item is BasicComponent:
					current.move_child(c_aux[next_item.key], i)
					current.control_node.move_child(c_aux[next_item.key].control_node, i)
				else:
					current.move_child(c_aux[next_item.key], i)
					current.control_node.move_child(c_aux[next_item.key].get_view().control_node, i)
				diff(current_item, next_item)
				
			ADD_AT:
				var children = next_item.get_children()
				for c in children:
					next_item.remove_child(c)
				next_item.replace_by(BasicComponent.new( {}, "nothing", []))
				
				for c in children:
					next_item.add_child(c)
					
				current.add_child(next_item)
				current.move_child(next_item, i)
				
				if next_item is BasicComponent:
					next_item.control_node = create_control(
						current.component_owner, 
						next_item.type, 
						next_item.props, 
						true
					)
					
					current.control_node.add_child(next_item.control_node)
					current.control_node.move_child(next_item.control_node, i)
					
					for child in next_item.get_children():
						render(next_item.control_node, child, current.component_owner)
				else:
					next_item.component_owner = current.component_owner
					next_item.complete()
					var view = next_item.get_view()
					var control = create_control(next_item, view.type, view.props, true)
					view.control_node = control
					current.control_node.add_child(control)
					current.control_node.move_child(control, i)
					
					for child in next_item.get_children():
						render(control, child, next_item)
						
					next_item.component_ready()
				
			DELETE:
				current.remove_child(current_item)
				current_item.delete()
			ADD:
				next_item.replace_by(BasicComponent.new({}, "nothing", []))
				current.add_child(next_item)
				render(current.control_node, next_item, current.component_owner)
		# end match
		i += 1 if operation != DELETE else 0
	# end while

func update_custom(current:Component, next:Component) -> void:
	current.props = next.props
	next.state = current.state
	next.complete()
	diff(current.get_view(), next.get_view())
	next.queue_free()
	await get_tree().process_frame
	current.component_updated()

# Renders the component to the scene
func render(parent:Control, component:BaseComponent, component_owner:Component = null) -> void:
	component.component_owner = component_owner
	
	if component is BasicComponent:
		component.control_node = create_control(component.component_owner, component.type, component.props, parent is Container)
		if component.props.has("ref"):
			component_owner[component.props.ref] = component.control_node
		parent.add_child(component.control_node)
		for child in component.get_children():
			render(component.control_node, child, component_owner)
	else:
		component.complete()
		render(parent, component.get_view(), component)
		await get_tree().process_frame
		component.component_ready()


func create_control(component_owner: Component, type:String, properties:Dictionary,child_of_container) -> Control:
	# Creates a control based on the type with the specified properties
	var node:Control
	match  type:
		"control": node = Control.new()
		"box": node = box_scene.instantiate()
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
		"subviewport"    :node = SubViewportContainer.new()
		"tabbox"         :node = TabContainer.new()
		"button"         :node = Button.new()
		"link_button"    :node = LinkButton.new()
		"texture_button" :node = TextureButton.new()
		"text_edit"      :node = TextEdit.new()
		"code_edit"      :node = CodeEdit.new()
		"color_rect"     :node = ColorRect.new()
		"color_picker"   :node = ColorPicker.new()
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
	set_properties(component_owner, node, {}, properties, child_of_container)
	return node


func set_properties(component_owner: Component, node:Control, last_properties, properties:Dictionary,child_of_container, ommit_signals=false) -> void:
	for key in properties.keys():
		if key == "id": continue
		elif key == "ref": continue
		elif key == "key": continue
		elif key == "list": continue
		elif key == "preset":
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
			
		elif key.begins_with("on_") and not ommit_signals:
			var signal_name = key.substr(3)
			component_owner.connect_signal(node[signal_name], properties[key])
		else:
			set_property(node, properties, key, child_of_container)

func connect_func(signal_name, callable):
	var obj = callable.get_object()
	

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
