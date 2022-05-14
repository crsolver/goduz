extends CustomComponent
class_name SecondsApp

func _init():
	super()
	state = {"seconds":0}

func ready():
	var timer = Timer.new()
	timer.timeout.connect(on_time_out)
	control.add_child(timer)
	timer.start(1)

func on_time_out():
	set_state({"seconds":state.seconds+1})

func render():
	return\
	Goo.center({"anchors": Control.PRESET_WIDE,},[
		Goo.label({"text":state.seconds})
	])
