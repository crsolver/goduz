extends CustomComponent
class_name CounterApp

func _init():
	super()
	state = {"count":0}

func increment():
	state.count = state.count+1
	update_gui()

func decrement():
	state.count = state.count-1
	update_gui()

func render():
	return\
	Goo.center({"anchors_preset": Control.PRESET_WIDE,},[
		Goo.hbox({},[
			Goo.button({"text":"-","on_pressed":decrement}),
			Goo.label({"text":str(state.count)}),
			Goo.button({"text":"+","on_pressed":increment})
		])
	])
