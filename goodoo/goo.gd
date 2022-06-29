extends Node
var presets:Dictionary

func add_preset(preset_name:String,node:Control):
	if not node.get_parent():
		add_child(node)
	presets[preset_name] = Utils.extract_properties(node)


func get_preset(preset_name:String):
#	print(preset_name)
	assert(presets.has(preset_name), "A preset not defined has been assigned to a component.")
	return presets[preset_name]

func initialize_presets():

	presets["top-left"] = { 
		anchors_preset = 0,
		clip_contents = true
	}
	presets["top-right"] = { 
		anchors_preset = 1,
		clip_contents = true
	}
	presets["bottom-right"] = { 
		anchors_preset = 2,
		clip_contents = true
	}
	presets["bottom-left"] = { 
		anchors_preset = 3,
		clip_contents = true
	}
	presets["top-left"] = { 
		anchors_preset = 4,
		clip_contents = true
	}
	presets["center-left"] = { 
		anchors_preset = 5,
		clip_contents = true
	}
	presets["center-top"] = { 
		anchors_preset = 6,
		clip_contents = true
	}
	presets["center-left"] = { 
		anchors_preset = 7,
	clip_contents = true
	}
	presets["center-bottom"] = { 
		anchors_preset = 8,
		clip_contents = true
	}
	presets["left-w"] = { 
		anchors_preset = 9,
		clip_contents = true
	}
	presets["top-w"] = { 
		anchors_preset = 10,
		clip_contents = true
	}
	presets["right-w"] = { 
		anchors_preset = 11,
		clip_contents = true
	}
	presets["bottom-w"] = { 
		anchors_preset = 12,
		clip_contents = true
	}
	presets["v-center-w"] = { 
		anchors_preset = 13,
		clip_contents = true}
	presets["h-center-w"] = { 
		anchors_preset = 14,
		clip_contents = true
	}
	presets["full"] = { 
		anchors_preset = 15,
		clip_contents = true
	}
	
	# child of containers
	presets["expand-h"] = {
		size_flags_horizontal = 3,
		size_flags_vertical = 0,
		clip_contents = true
	}
	presets["expand-v"] = {
		size_flags_horizontal = 3,
		size_flags_vertical = 0,
		clip_contents = true
	}
	presets["expand"] = {
		size_flags_horizontal = 3,
		size_flags_vertical = 3,
		clip_contents = true
	}
	
	Presets.initialize_presets()
	var pks = Utils.get_controls_from_path("visual_presets")
	var nodes = []
	for pk in pks:
		nodes.append(pk)
	for node in nodes:
		create_presets_from_control(node)


func create_presets_from_control(node:Control):
	if not str(node.name).begins_with("_"):
		add_preset(node.name, node)
	for child in node.get_children():
		create_presets_from_control(child)
	node.queue_free()


func control(properties:Dictionary={}, children=[]):
	return BasicComponent.new(properties, "control", children)


# Containers
func container(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"container", children)

func aspect_radio(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"aspect_radio_container", children)

func center(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"center", children)

func hbox(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties, "hbox", children)

func vbox(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties, "vbox", children)

func graphnode(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"graphnode", children)

func grid(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"grid", children)

func hflow(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"hflow", children)

func vflow(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"vflow", children)

func hsplit(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"hsplit", children)

func vsplit(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"vsplit", children)

func margin(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"margin", children)

func panel_container(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"panel", children)

func scrollbox(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"scrollbox", children)

func subviewport(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"subviewport", children)

func tabbox(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"tab", children)


# Buttons

func button(properties:Dictionary={}):
	return BasicComponent.new(properties,"button", [])

func link_button(properties:Dictionary={}):
	return BasicComponent.new(properties,"link_button", [])

func texture_button(properties:Dictionary={}):
	return BasicComponent.new(properties,"texture_button", [])



func text_edit(properties:Dictionary={}):
	return BasicComponent.new(properties,"text_edit", [])

func code_edit(properties:Dictionary={}):
	return BasicComponent.new(properties,"code_edit", [])

func color_rect(properties:Dictionary={}):
	return BasicComponent.new(properties,"color_rect", [])

func graph_edit(properties:Dictionary={}):
	return BasicComponent.new(properties,"graph_edit", [])

func hscrollbar(properties:Dictionary={}):
	return BasicComponent.new(properties,"vscrollbar", [])

func vscrollbar(properties:Dictionary={}):
	return BasicComponent.new(properties,"vscrollbar", [])

func vslider(properties:Dictionary={}):
	return BasicComponent.new(properties,"vslider", [])

func hslider(properties:Dictionary={}):
	return BasicComponent.new(properties,"hslider", [])

func progressbar(properties:Dictionary={}):
	return BasicComponent.new(properties,"progressbar", [])

func spinbox(properties:Dictionary={}):
	return BasicComponent.new(properties,"spinbox", [])

func texture_progress_bar(properties:Dictionary={}):
	return BasicComponent.new(properties,"texture_progress_bar", [])

func vseparator(properties:Dictionary={}):
	return BasicComponent.new(properties,"vseparator", [])
	
func hseparator(properties:Dictionary={}):
	return BasicComponent.new(properties,"hseparator", [])

func item_list(properties:Dictionary={}):
	return BasicComponent.new(properties,"item_list", [])

func label(properties:Dictionary={}):
	return BasicComponent.new(properties,"label", [])

func line_edit(properties:Dictionary={}):
	return BasicComponent.new(properties,"line_edit", [])

func nine_patch_rect(properties:Dictionary={}):
	return BasicComponent.new(properties,"nine_patch_rect", [])

func panel(properties:Dictionary={},children:Array=[]):
	return BasicComponent.new(properties,"panel", children)

func reference_rect(properties:Dictionary={}):
	return BasicComponent.new(properties,"reference_rect", [])
	
func rich_label(properties:Dictionary={}):
	return BasicComponent.new(properties,"rich_label", [])	

func tab_bar(properties:Dictionary={}, children:Array=[]):
	return BasicComponent.new(properties,"tab_bar", children)

func texture_rect(properties:Dictionary={}):
	return BasicComponent.new(properties,"texture_rect", [])

func tree(properties:Dictionary={}):
	return BasicComponent.new(properties,"tree", [])

