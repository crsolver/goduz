extends Component
class_name Counter

# Called when the component is initialized. Use it to initialize the state.
func _init():
	super("counter") # Pass a string to identify objects of this class
	state = {
		count = 0
	}

# LIFECYCLE METHODS_________________________________________________________________________________
# Called after the component has been rendered to the screen the first time.
func component_ready():
	pass

# Called after the view of this component has been updated.
func component_updated():
	pass

# Called before the component is destroyed.
func component_will_die():
	pass

# COMPONENT LOGIC___________________________________________________________________________________
func increment():
	state.count += 1
	update_view()

func decrement(): 
	state.count -= 1
	update_view()

# VIEW_____________________________________________________________________________________________
func view():
	return\
	Gui.center({preset="full"}, [# Use preset="full" to expand BasicComponents (control nodes).
		Gui.hbox({preset="expand"},[ # Use preset="expand" to expand BasicComponents (control nodes) that are children of containers.
			Gui.button({text="-", on_pressed=decrement}), # signals begin with on_
			Gui.label({text=str(state.count)}),
			Gui.button({text="+", on_pressed=increment})
		])
	])
