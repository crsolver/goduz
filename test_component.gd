extends CustomComponent

class_name Test

func _init():
	print("creating test compo 1")
	super("test")
	state = {"count":0}

func handle_change():
	print(get_control("b"))

func gui():
	return\
	Goo.center({"preset":"center","id":"b"},[
		Goo.vbox({"preset":"vbox"},[
			Goo.button({"preset": "red-button", "text":"red", "on_pressed":func(): print("button was pressed")}),
			Goo.panel({"preset":"center"}, [
				Goo.label({"text":"blabla"})
			])
		])
	])
