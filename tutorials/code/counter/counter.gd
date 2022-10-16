class_name Counter extends BaseRootComponent

func _init():
	super()
	state.count = 0

func decrease(): state.count -= 1
func increase(): state.count += 1

func view():
	return\
	hbox({preset="center"},[
		button({text="-", on_pressed=decrease}),
		label({text=str(state.count)}),
		button({text="+", on_pressed=increase}),
	])
