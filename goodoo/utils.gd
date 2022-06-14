extends Node

const EXCEPTIONS = [
	"name",
	"Transform",
	"transform",
	"_import_path",
	"unique_name_in_owner",
	"scene_file_path",
	"owner",
	"size",
	"scale",
	"rotation",
	"position",
	"global_position", 
	"text"]

func dict_to_json(dict):
	var json = JSON.new()
	return json.stringify(dict,"\t",false)

func extract_properties(control:Control) -> Dictionary:
	var dict = control.get_property_list()
	var props = {}
	if control is MarginContainer:
		props.const_margin_right = control.get_theme_constant("margin_right")
		props.const_margin_top = control.get_theme_constant("margin_top")
		props.const_margin_left = control.get_theme_constant("margin_left")
		props.const_margin_bottom = control.get_theme_constant("margin_bottom")
		
	for prop in dict:
		if EXCEPTIONS.count(prop.name)>0: 
			continue
		if control.get(prop.name) != null:
			props[prop.name] = control.get(prop.name)
	print("____________")
	print(control.name)
	print(dict_to_json(props))
	return props

func get_controls_from_path(path):
	var controls = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var control = load("res://"+path+"/"+file_name)
				controls.append(control.instantiate())
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return controls
