extends CustomComponent

class_name App

func _init():
	#Always call super()
	super()
#	state = {}

#func ready():

func gui():
	return\
	Goo.center({"preset":"center"},[
		Goo.label({"text":"goodoo"})
	])
