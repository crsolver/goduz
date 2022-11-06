extends Node
# Methods to render and update the view.

@onready
var box_scene = preload("res://addons/goduz/custom_controls/box.tscn")

# To do
# [ ] Fix: Lambdas cause unnecesary updates in control nodes (they are created every time view() is called causing the props to be different)
# [ ] Better algorithm for updating lists, the current one is just to have it working


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
	
#	if next_view.type != current.type:
	var new_control = create_control(current.owner_component, next_view.type, next_view.props,is_child_of_container)
	current.control_node.replace_by(new_control)
	next_control = new_control
	old_control.queue_free()
#	else:
#		set_properties(current.owner_component, current.control, current.props, next_view.props,is_child_of_container)
#
	for child in next.get_view().get_children():
		render(next_control, child, current.owner_component)
	
	next.get_parent().remove_child(next)
	next_view.get_parent().remove_child(next_view)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.view_container.add_child(next_view)
	next.get_view().control_node = next_control
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()

func change_custom_for_basic(current:Component, next:BasicComponent) -> void:
	current.component_will_die()
	
	for child in current.get_view().control_node.get_children():
		child.queue_free()
	
	var next_control = current.get_view().control_node
	
	if current.get_view().type != next.type:
		var old = current.get_view().control_node
		var child_of_container = old.get_parent() is Container
		var new = create_control(current.owner_component, next.type, next.props,child_of_container)
		
		if old is ScrollContainer:
			old.get_h_scroll_bar().queue_free()
			old.get_v_scroll_bar().queue_free()
		
		current.get_view().control_node.replace_by(new)
		old.queue_free()
		next_control = new
		
	elif current.props.hash() != next.props.hash():
		update_basic(current.get_view(), next)
	
	for child in next.get_children():
		render(current.get_view().control_node, child, current.owner_compent)
	
	next.get_parent().remove_child(next)
	current.view_container.free()
	current.control_node.free()
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
	
	if current.list: return
	
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
	var new = create_control(current.owner_component, next.type, next.props, old.get_parent() is Container)
	
	for child in old.get_children():
		child.queue_free()
	
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
	var next_control
	var current_view = current.get_view()
	var next_view = next.get_view()
	
	var old_control = current_view.control_node
	next_control = old_control
	
	for child in old_control.get_children():
		child.queue_free()
	
	var child_of_container = old_control.get_parent() is Container
	
	var new_control = create_control(current.owner_component, next_view.type, next_view.props,child_of_container)
	current_view.control_node.replace_by(new_control)
	next_control = new_control
	old_control.queue_free()
	
	for child in next.get_view().get_children():
		render(next_control, child, current.owner_component)
	
	var c_parent = current.parent_control
	var container = current.view_container
	
	next.get_parent().remove_child(next)
	next_view.get_parent().remove_child(next_view)
	
	current.replace_by(next)
	next.parent_control = c_parent
	next.view_container.add_child(next_view)
	next.get_view().control_node = next_control
	container.queue_free()
	current.control_node.queue_free()
	current.queue_free()
	await get_tree().process_frame
	next.component_ready()


func update_basic(current:BasicComponent, next:BasicComponent) -> void:
#	print("updating "+current.type)
	var child_of_container = current.control_node.get_parent() is Container
	set_properties(current.owner_component, current.control_node, current.props, next.props,child_of_container, true)
	current.props = next.props
	
	if current.list != null:
		update_list(current, next)


func update_list(current:BasicComponent, next:BasicComponent):
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
	
	var offset = 0
	var j = 0
	var i = 0
	
#	for i in range(0, end):
	while (i+offset) < max(current.get_child_count(), next.get_child_count()):
		var current_item = null
		var next_item = null
		if i+offset < current.get_child_count(): current_item = current.get_child(i+offset)
		if i+offset < next.get_child_count(): next_item = next.get_child(i+offset)
		
		print(str(i+offset) + "............................")
		if current_item:
			print("current: " + str(current_item.key))
		else:
			print("current: null")
		if next_item:
			print("AGAINS")
			print("next: " + str(next_item.key))
		
		
		if next_item:
			if current_item: # if the are the same continue
				if next_item.key == current_item.key: 
					diff(current_item, next_item)
					print("same")
					i+=1
					continue
				else:
					if n_aux.has(current_item.key):
						if c_aux.has(next_item.key):
#							 move item to i
							print("move " + c_aux[next_item].key + " to " + str(i + offset))
							if next_item is BasicComponent:
								current.move_child(c_aux[next_item.key], i+offset)
								current.control_node.move_child(c_aux[next_item.key].control_node, i+offset)
							else:
								current.move_child(c_aux[next_item.key], i+offset)
								current.control_node.move_child(c_aux[next_item.key].get_view().control_node, i+offset)
							diff(current_item, next_item)
						else:
							#add new on i
							print("add new ("+ next_item.key +") in " + str(i + offset))
							
							var children = next_item.get_children()
							for c in children:
								next_item.remove_child(c)
							next_item.replace_by(BasicComponent.new( {}, "nothing", []))
							for c in children:
								next_item.add_child(c)
							current_size += 1
							
#							next.remove_child(next_item)
							current.add_child(next_item)
							current.move_child(next_item, i+offset)
							
							if next_item is BasicComponent:
								next_item.control_node = create_control(current.owner_component, next_item.type, next_item.props, true)
								current.control_node.add_child(next_item.control_node)
								current.control_node.move_child(next_item.control_node, i+offset)
								for child in next_item.get_children():
									render(next_item.control_node, child, current.owner_component)
							else:
								next_item.owner_component = current.owner_component
								next_item.complete()
								var view = next_item.get_view()
								var control = create_control(next_item, view.type, view.props, true)
								view.control_node = control
								current.control_node.add_child(control)
								current.control_node.move_child(control, i+offset)
								for child in next_item.view_container.get_children():
									render(control, child, next_item)
								next_item.component_ready()
					else:
						print("delete " + str(current_item.key))
						current.remove_child(current_item)
						current_item.delete()
						offset -= 1
						current_size -= 1
			# if no prev_item
			else:
				# create item
				next.remove_child(next_item)
				current.add_child(next_item)
				print("create item (" + str(next_item.key)+")")
				render(current.control_node, next_item, current.owner_component)
				current_size += 1
		# if not item
		else:
			if current_item:
				print("remove (" + str(current_item.key))
				current_item.delete()
				current.remove_child(current_item)
				offset -= 1
				current_size -= 1
			else:
				return
		i += 1


func update_custom(current:Component, next:Component) -> void:
	current.props = next.props
	next.state = current.state
	next.complete()
	diff(current.get_view(), next.get_view())
	next.queue_free()
	await get_tree().process_frame
	current.component_updated()

# Renders the component to the scene
func render(parent:Control, component:BaseComponent, owner:Component) -> void:
	component.owner_component = owner
	
	if component is BasicComponent:
		component.control_node = create_control(component.owner_component, component.type, component.props, parent is Container)
		if component.props.has("assign_to"):
			owner[component.props.assign_to] = component.control_node
		parent.add_child(component.control_node)
		for child in component.get_children():
			render(component.control_node, child, owner)
	else:
		component.complete()
		component.parent_control = parent
		render(parent, component.get_view(), component)
		await get_tree().process_frame
		component.component_ready()


func create_control(owner: Component, type:String, properties:Dictionary,child_of_container) -> Control:
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
	set_properties(owner, node, {}, properties, child_of_container)
	return node


func set_properties(owner: Component, node:Control, last_properties, properties:Dictionary,child_of_container, ommit_signals=false) -> void:
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
			
		elif key.begins_with("on_") and not ommit_signals:
			var signal_name = key.substr(3)
			owner.connect_signal(node[signal_name], properties[key])
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
