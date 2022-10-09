extends Button


func _on_reload_components_pressed():
	var root
	for child in get_parent().get_parent().get_children():
		if child is RootComponent:
			root = child
			break
	
	var new_root = RootComponent.new()
	get_parent().get_parent().add_child(new_root)
#	get_parent().move_child(self, get_parent().get_child_count()-1)

	root.root_control.queue_free()
	root.queue_free()
	get_parent().queue_free()
