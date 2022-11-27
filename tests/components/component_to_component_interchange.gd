class_name ComponentToComponentInterchange extends Component


func _init():
	super()
	state.show_1 = true

func change():
	state.show_1 = !state.show_1


func view():
	return \
	vbox({preset="expand-h"}, [
		label({text="Component to Component interchange"}),
		hbox({preset="expand-h"}, [
			button({text="change", on_pressed=change}),
			Component1.new() if state.show_1 else Component2.new(),
			label({text="last"})
		])
	])
