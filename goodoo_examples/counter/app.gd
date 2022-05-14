extends CustomComponent
class_name CounterApp

func _init():
	super()
	state = {"count":0}

func increment():
	set_state({"count":state.count+1})

func decrement():
	set_state({"count":state.count-1})

func render():
	return\
	Goo.center({"anchors": Control.PRESET_WIDE,},[
		Goo.hbox({},[
			Goo.button({"text":"-","onClick":decrement}),
			Goo.label({"text":state.count}),
			Goo.button({"text":"+","onClick":increment})
		])
	])
