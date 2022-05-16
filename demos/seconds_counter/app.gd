extends CustomComponent
class_name SecondsApp

var tween:Tween

func _init():
	super()
	state = {"seconds":0}

func ready():
	var timer = Timer.new()
	timer.timeout.connect(on_time_out)
	control.add_child(timer)
	timer.start(1)

func on_time_out():
	state.seconds = state.seconds+1
	update_gui() #always call this method after changing the state

func render():
	return\
	Goo.center({"anchors_preset": Control.PRESET_WIDE},[
		Goo.label({"text":str(state.seconds)})
	])
