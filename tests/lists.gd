extends Component
class_name List

func _init():
	super()
	state = {
		items= ["one", "two", "three", "four"]
	}

func view():
	return \
	Gui.center({preset="full"}, [
		Gui.vbox({preset="full", list=state.items.hash()}, 
			state.items.map(func(item): return Gui.label({text=item, key=item}))
		)
	])
