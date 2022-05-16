extends Node

func dict_to_json(dict):
	var json = JSON.new()
	return json.stringify(dict,"\t",false)

func extract_properties(control) -> Dictionary:
	var dict = control.get_property_list()
	var props = {}
	for prop in dict:
		if control.get(prop.name):
			if ["Transform", "size", "position", "global_position"].count(prop.name)>0: continue
			props[prop.name] = control.get(prop.name)
	control.queue_free()
	props.erase("name")
	return props

