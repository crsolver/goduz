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
	pass
#	# Return the component tree as a dictionary.
#	var children_data = []
#	for child in get_gui():
#		children_data.append(child.get_data())
#
#	var data = {
#		"type": type,
#		"input": input,
#		"children": children_data,
#		"control": control
#	}
#	return data


func get_control(_value):
	pass
