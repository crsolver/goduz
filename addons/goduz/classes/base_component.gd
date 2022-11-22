extends Node
class_name BaseComponent# "res://addons/goduz/assets/goduz_icon.svg"
# Author: Andres Gamboa

# There are two types of components:
# BasicComponents: 
#	Represent simple Godot control nodes.
#	For a better and more readable code they are created using Goo.
#	For example: Goo.button(properties) # the same that: BasicComponent.new(properties,"button", [])

# Components: 
#	custom components. 
#	Their view is defined with the gui() function which returns a BasicComponent with nested 
#	children (more BasicComponents or 'custom' Components)

# There is also a RootComponent which inherits from Component.
# This component can be added to a scene and it will render itself.

var props
var type

func _init():
	pass

func get_data():
	pass


func get_control(_value):
	pass
