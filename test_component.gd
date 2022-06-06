extends CustomComponent

class_name Test

func _init(_input):
	super("test",_input)
	state = {"count":0}

func handle_change():
	state.count += 1
	update_gui()

func gui():
	return\
	Goo.control({"preset":"center"},[
		Goo.label({"text":"goodoo"}),
		Goo.vbox({"preset":"vbox"},[
			Goo.button({"preset": "red-button left-button", "text":"button", "on_pressed":handle_change})
		])
	])
