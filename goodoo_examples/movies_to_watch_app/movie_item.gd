extends CustomComponent
class_name MovieItem

func _init(_input={}):
	super(_input)


func render():
	return\
	Goo.margin({
		"min_size": Vector2(0,35),
		"set": [2,2,2,2]},[
		Goo.panel({},[
			Goo.hbox({}, [
				Goo.label({
					"text":input.text,
					"autowrap": Label.AUTOWRAP_WORD,
					"expand": true}),
			]),
		])
	])
