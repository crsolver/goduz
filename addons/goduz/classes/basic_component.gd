extends BaseComponent
class_name BasicComponent
# Author: Andres Gamboa

var list = false
var key = null
var component_owner
var control_node: Control
func _init(_props:Dictionary, _type:String, children:Array):
	type = _type
	props = _props.duplicate(true)

	if props.has("list"):
		list = props.list

	if props.has("key"):
		key = props.key

	for child in children:
		add_child(child)


func get_control(id) -> Control:
	for child in get_children():
		if child.props.has("id"):
			if child.props.id == id:
				return child.control_node
		var found = child.get_control(id)
		if found:
			return found
	return null

func delete():
	if control_node: control_node.queue_free()
	queue_free()

#func get_data():
#	var children_data = []
#	for child in get_children():
#		children_data.append(child.get_data())
#
#	var data = {
#		"type": type,
#		"props": props,
#		"children": children_data,
#		"control": control,
#		"parent": control.get_parent()
#	}
#	return data
