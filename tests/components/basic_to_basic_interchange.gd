class_name BasicToBasicInterchange extends Component


func _init():
	super()
	state.show_label = true

func change():
	state.show_label = !state.show_label

func component_ready():
	print(holder)

func view():
	return \
	vbox({preset="expand-h"}, [
		label({text="BasicComponent to BasicComponent interchange"}),
		hbox({preset="expand-h"}, [
			button({text="change", on_pressed=change}),
			button({text="button"}) if state.show_label 
			else 
			label({text="label"})
		])
	])

