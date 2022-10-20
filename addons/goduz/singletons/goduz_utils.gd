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
	"theme_override_constants",
	"text"
]

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
	return props

func _get_all_controls(control:Control):
	var arr = []
	arr.append(control)
	for child in control.get_children():
		arr.append_array(_get_all_controls(child))
	return arr

func _get_controls_from_file(path):
	var control = load(path)
	return _get_all_controls(control.instantiate())

func get_presets_from_file(path):
	var props = _get_props(path)
	var controls = _get_controls_from_file(path)
	for c in controls:
		if props.has(c.name):
			for k in props[c.name].keys():
				props[c.name][k] = c[k]
				
			if c is MarginContainer:
				var mr = c.get_theme_constant("margin_right")
				var mt = c.get_theme_constant("margin_top")
				var ml = c.get_theme_constant("margin_left")
				var mb = c.get_theme_constant("margin_bottom")
				if mr != 0:
					props[c.name].const_margin_right = mr
				if mt != 0:
					props[c.name].const_margin_top = mt
				if ml != 0:
					props[c.name].const_margin_left = ml
				if mb != 0:
					props[c.name].const_margin_bottom = mb
	controls[0].queue_free()
	return props

func _get_props(file):
	var obj = {}
	var current_control
	var f = FileAccess.open(file, FileAccess.READ)
	var _index = 1
	var block = false
	while not f.eof_reached():
		var line = f.get_line()
		line += " "
		if line.begins_with("[node"):
			block = false
			var _name = line.split('"')[1]
			if !_name.begins_with("_"):
				current_control = _name
				obj[_name] = {}
		elif line.begins_with("[sub"):
			block = true
		elif !line.begins_with("[") and not block:
			var split = line.split("=")
			if split.size() == 2:
				var prop = line.split("=")[0].dedent().split(" ")[0]
				if prop == null: continue
				if EXCEPTIONS.count(prop) < 1 and !prop.begins_with("theme_override_constants") and !prop.begins_with("offset"):
					if current_control:
						obj[current_control][prop] = null
		_index += 1
#	f.close()
	return obj
