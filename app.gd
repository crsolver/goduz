extends CustomComponent

class_name App

func _init():
	super("app")
	state = {"count":0}

func handle_change():
	state.count += 1
	update_gui()

func component(count):
	if count % 2 == 0:
		print("returning test")
		return Test.new()
	else:
		print("returning test2")
	return Test2.new()

func gui():
	return\
	Goo.vbox({"preset":"vbox"},[
		Goo.label({"text":"goodoo"}),
		Goo.vbox({"preset":"vbox"},[
			Goo.button({"text":"button", "on_pressed":handle_change})
		]),
		component(state.count)
	])
