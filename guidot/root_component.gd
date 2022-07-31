extends BaseRootComponent
class_name RootComponent

# Called when the component is initialized. Use it to initialize the state.
func _init():
	super()
#	Path of the scene with control nodes to be used as presets:
#	presets_path = "res://preset.tscn"
	state = {count=0}


# Called when the component has been rendered to the screen the first time.
func component_ready():
	pass


# Called when the view of this component has been updated.
func component_updated():
	pass


func increment():
	state.count += 1
	update_view()


func decrement(): 
	state.count -= 1
	update_view()


# Defined by BasicComponents created using Gui 'Gui.center()' or other Components 'MyComponent.new()'.
func view():
	return\
	Gui.center({preset="full"}, [# Use preset="full" to expand BasicComponents (control nodes).
		Gui.hbox({preset="expand"},[ # Use preset="expand" to expand BasicComponents (control nodes) that are children of containers.
			Gui.button({text="-", on_pressed=decrement}), # signals begin with on_
			Gui.label({text=str(state.count)}),
			Gui.button({text="+", on_pressed=increment})
		])
	])
