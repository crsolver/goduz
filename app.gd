extends CustomComponent

class_name App

var count = 0
var http:HTTPRequest

func _init():
	#Always call super()
	super()
	state = {}

func ready():
	pass

func render():
	return\
	Goo.center({"anchors": Control.PRESET_WIDE,},[
		Goo.rich_label({"text":"[center][wave]Goodoo[/wave][/center]"})
	])
