extends CustomComponent

class_name Test2

func _init():
	super("test2")
	state = {"count":0}

func handle_change():
	print(get_control("b"))

func gui():
	return\
	Goo.vbox({"id":"b","preset":"vbox"},[
		Goo.vbox({"preset":"vbox"},[
			Goo.label({"text":"label"})
		])
	])
