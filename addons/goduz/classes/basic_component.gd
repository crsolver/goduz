extends BaseComponent
class_name BasicComponent
# Author: Andres Gamboa

var list = false
var key
var holder
var control: Control

func _init(props:Dictionary, type:String, children:Array):
	self.type = type
	self.props = props.duplicate(true)

	if props.has("list"): list = props.list
	if props.has("key"): key = props.key

	for child in children: 
		if child.get_parent(): child.get_parent().remove_child(child)
		add_child(child)


func get_control(id) -> Control:
	for child in get_children():
		if child.props.has("id"):
			if child.props.id == id:
				return child.control
		var found = child.get_control(id)
		if found:
			return found
	return null
