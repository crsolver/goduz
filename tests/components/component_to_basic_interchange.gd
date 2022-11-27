class_name ComponentToBasicInterchange extends Component

func _init():
	super()
	state.show_component = true

func change():
	state.show_component = !state.show_component


func view():
	var comp:BaseComponent
	if state.show_component:
		comp = Component1.new()
	else:
		comp = label({text="label"})
	return \
	vbox({preset="expand-h"}, [
		label({text="Component to Basic interchange"}),
		hbox({preset="expand-h"}, [
			button({text="change", on_pressed=change}),
			comp
		])
	])
