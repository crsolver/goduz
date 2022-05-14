extends Node

# Goo creates BasicComponents (An object representation of a godot control node)
# The method Goodoo.create_control() will create the control node based on the type(second argument) of the BasicComponent
# Not all control nodes are supported yet, but you can create a method here that returns a BasicComponent representing
# the control node that you want, just make sure to add the corresponding code to create the control node in
# the Goodoo.create_control() method. That also means that you can use your own custom control node, as
# long as you do the necessary steps.

# This methods exist because is more convenient to write:
# Goo.button({"onClick":func}) than:
# BasicComponent.new({"onClick":func}, "button", [])
# and is also more readable in the render method.

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

func scroll_vbox(properties={}, children=[]):
	# This component will have an VBoxContainer as a child by default
	var node = BasicComponent.new(properties,"scroll", [
		BasicComponent.new({"expand":true},"vbox", children)
	])
	return node

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
