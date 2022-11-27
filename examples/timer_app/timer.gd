class_name Responsive extends BaseRootComponent

var c: Control

func _init():
	super()
	state.horizontal = true

func _process(delta):
	if c.size.x < 300 and state.horizontal:
		state.horizontal = false
		update_view()
	elif c.size.x >= 300 and not state.horizontal:
		state.horizontal = true
		update_view()

func view():
	var children = [
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
		button({text="button"}),
	]
	return control({preset="full", ref="c"},[
		hbox({preset="full", id="container"}, children) if state.horizontal else vbox({preset="full", id="container"}, children)
	])
