extends CustomComponent
class_name MovieList

func _init(_input={}):
	super(_input)


func render():
	var items = []
	for item in input.items:
		items.append(MovieItem.new({"text":item.todo}))
	
	return\
	Goo.scroll_vbox({
		"min_size":Vector2(0,420),
		"clip":true},
		items)
