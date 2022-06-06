extends CustomComponent

class_name App

func _init():
	#Always call super()
	super()
#	state = {}

#func ready():

func gui():
	return\
	Goo.control({"preset":"center"},[
		Goo.label({"text":"goodoo"}),
		Goo.vbox({"preset":"vbox"},[
			Goo.button({"preset": "red-button left-button", "text":"button"})
		])
	])
