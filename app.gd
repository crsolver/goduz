extends CustomComponent

class_name App

func _init():
	#Always call super()
	super()
#	state = {}

#func ready():

func render():
	return\
	Goo.center({"preset":"app"},[
		Goo.rich_label({
			"text":"[center][wave]Goodoo[/wave][/center]"
		}),
	])
