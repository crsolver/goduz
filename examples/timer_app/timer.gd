class_name TimerApp extends BaseRootComponent

func _init():
	super()
	state.seconds = 0

func component_ready():
	var timer = Timer.new()
	include(timer)
	timer.wait_time = 1
	connect_signal(timer.timeout, on_timer_timeout)
	timer.start()

func on_timer_timeout():
	state.seconds += 1

func view():
	return label({preset="center", text=str(state.seconds)})
