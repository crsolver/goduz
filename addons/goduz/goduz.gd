@tool
extends EditorPlugin
# Author: Andres Gamboa

func _enter_tree():
	add_autoload_singleton("Goduz", "res://addons/goduz/singletons/goduz.gd")
	add_autoload_singleton("Gui", "res://addons/goduz/singletons/gui.gd")
	add_autoload_singleton("GoduzUtils", "res://addons/goduz/singletons/goduz_utils.gd")
	add_custom_type("RootComponent", "Node", load("res://addons/goduz/classes/root_component.gd"), Texture2D.new())
	#get_editor_interface().get_resource_filesystem().connect("filesystem_changed",func(): print("something changed"))

func _exit_tree():
	remove_autoload_singleton("Guidot")
	remove_autoload_singleton("Gui")
	remove_autoload_singleton("GuidotUtils")
	remove_custom_type("RootComponent")
