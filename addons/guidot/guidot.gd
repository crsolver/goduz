@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Guidot", "res://addons/guidot/singletons/guidot.gd")
	add_autoload_singleton("Gui", "res://addons/guidot/singletons/gui.gd")
	add_autoload_singleton("GuidotUtils", "res://addons/guidot/singletons/guidot_utils.gd")
	add_custom_type("RootComponent", "Node", load("res://addons/guidot/classes/root_component.gd"), Texture2D.new())
	
func _exit_tree():
	remove_autoload_singleton("Guidot")
	remove_autoload_singleton("Gui")
	remove_autoload_singleton("GuidotUtils")
	remove_custom_type("RootComponent")
