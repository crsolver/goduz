extends CustomComponent

class_name App

func _init():
	#Always call super()
	super()
#	state = {}

#func ready():

func gui():
	return\
	Goo.margin({"preset":"margin"},[
		Goo.scroll({"preset":"scroll"},[
			Goo.vbox({"preset":"vbox"},[
				Goo.button({"preset":"primary","text":"click"}),
				Goo.button({"preset":"secundary","text":"click"})
			])
		])
	])
