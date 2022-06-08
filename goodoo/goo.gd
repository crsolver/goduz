extends Node
var presets:Dictionary

func add_preset(preset_name:String,node:Control):
	if not node.get_parent():
		add_child(node)
	presets[preset_name] = Utils.extract_properties(node)


func get_preset(preset_name:String):
	assert(presets.has(preset_name), "A preset not defined has been assigned to a component.")
	return presets[preset_name]
	
func initialize_presets():
	Presets.initialize_presets()
	var pks = Utils.get_controls_from_path("visual_presets")
	var nodes = []
	for pk in pks:
		nodes.append(pk)
	for node in nodes:
		create_presets_from_control(node)

func create_presets_from_control(node:Control):
	if not str(node.name).begins_with("_"):
		print("creting preset for " + str(node.name))
		add_preset(node.name, node)
	for child in node.get_children():
		create_presets_from_control(child)
	node.queue_free()


func panel_hover():
	return load("res://goodoo_examples/movies_to_watch_app/on_panel_hover_theme.tres")

func margin(properties={}, children=[]):
	return BasicComponent.new(properties,"margin", children)

func panel(properties={}, children=[]):
	return BasicComponent.new(properties,"panel", children)

func center(properties={}, children=[]):
	return BasicComponent.new(properties,"center", children)

func label(properties={}):
	return BasicComponent.new(properties,"label", [])

func rich_label(properties={}):
	return BasicComponent.new(properties,"rich_label", [])	

func vbox(properties={}, children=[]):
	return BasicComponent.new(properties, "vbox", children)

func scroll(properties={}, children=[]):
	return BasicComponent.new(properties,"scroll", children)

func hbox(properties={}, children=[]):
	return BasicComponent.new(properties, "hbox", children)

func control(properties={}, children=[]):
	return BasicComponent.new(properties, "control", children)

func button(properties={}):
	return BasicComponent.new(properties, "button", [])

func text_edit(properties={}):
	return BasicComponent.new(properties,"text_edit", [])

func line_edit(properties={}):
	return BasicComponent.new(properties,"line_edit", [])
