extends CustomComponent

class_name Test2

func _init():
	super("test2")
	state = {"count":0}

func handle_change():
	print(get_control("b"))

func gui():
	return\
	Goo.center({"id":"b","preset":"center"},[
		Goo.vbox({"preset":"vbox"},[
			Goo.button({"preset":"green-button","text":"green"})
		])
	])
