class_name TimerApp extends BaseRootComponent

var timer: Timer

func _init():
	super()
	state.seconds = 0

func component_ready():
	timer = Timer.new()
	control_node.add_child(timer)
	timer.wait_time = 1
	connect_signal(timer.timeout, on_timer_timeout)
	timer.start()

func on_timer_timeout():
	state.seconds += 1

func view():
	return label({
		preset="center", 
		text=str(state.seconds)
	})
