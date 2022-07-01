extends BaseRootComponent
class_name RootComponent

# Called when the component is initialized. Use it to initialize the state.
func _init():
	super()
#	Path of the scene with control nodes to be used as presets:
#	presets_path = "res://presets.tscn"
	state = {count=0}


# Called when the component has been rendered to the screen the first time.
# Note: Don't use _ready() (with underscore).
func ready():
	pass


# Called when the gui of this component has been updated.
func updated():
	pass

func increment():
	state.count += 1

func decrement():
	state.count -= 1

# The view of the component. 
# Defined by BasicComponents created using Goo 'Goo.center()' or other Components 'MyComponent.new()'.
func gui():
	return\
	Goo.center({preset="full"},[ # Use preset="full" to expand BasicComponents (control nodes).
		Goo.hbox({preset="expand"},[ # Use preset="expand" to expand BasicComponents (control nodes) that are children of containers.
			Goo.button({text="-", on_pressed=decrement}), # signals begin with on_
			Goo.label({text=str(state.count)}),
			Goo.button({text="+", on_pressed=increment})
		])
	])
