extends Button
# Author: Andres Gamboa

func _on_reload_components_pressed():
	var root
	for child in get_parent().get_children():
		if child is RootComponent:
			root = child
			break
	root.root_control.queue_free()
	root.queue_free()
	
	var new_root = RootComponent.new()
	add_sibling(new_root)
	get_parent().move_child(self, get_parent().get_child_count()-1)
