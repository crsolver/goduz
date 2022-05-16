extends Node

class_name Component

var input
var type
var control

func _init():
	pass

func ready():
	pass

func render():
	pass

func get_components():
	pass
	
func updated():
	pass

func about_to_die():
	pass

func get_data():
	# Return the component tree as a dictionary.
	var children_data = []
	for child in get_components():
		children_data.append(child.get_data())
		
	var data = {
		"type": type,
		"input": input,
		"children": children_data,
	}
	return data


func get_control(value):
	for child in get_components():
		if child.input.has("id"):
			if child.input.id == value:
				return child.control
		return child.get_control(value)
