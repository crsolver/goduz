extends CustomComponent

class_name Counter

func _init():
	super("counter")
	state = {"count": 0}

func decrease():
	state.count = state.count - 1
	update_gui()

func increase():
	state.count = state.count + 1
	update_gui()

func gui():
	return\
	Goo.center({},[
		Goo.hbox({},[
			Goo.button({
				"text":"-", 
				"on_pressed":decrease
			}),
			Goo.label({"text": str(state.count)}),
			Goo.button({
				"text":"+", 
				"on_pressed":increase
			}),
		])
	])
