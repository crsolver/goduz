extends CustomComponent
class_name MovieItem

var item:Control
func _init(_input={}):
	super(_input)

func ready():
	item = get_control("movieItem")
	var tween = item.create_tween()
	tween.set_parallel(true)
	tween.tween_property(item, "position:x", item.position.x, 0.3).from(item.position.x-20).set_trans(Tween.EASE_IN_OUT)
	tween.tween_property(item, "modulate", Color(1,1,1,1), 0.3).from(Color(1,1,1,0)).set_trans(Tween.EASE_IN_OUT)


func render():
	return\
	Goo.panel({
		"id":"movieItem"},[
		Goo.hbox({"size_flags_horizontal": Control.SIZE_EXPAND_FILL}, [
			Goo.label({
				"text":input.text,
				"autowrap_mode": Label.AUTOWRAP_WORD,
				"size_flags_horizontal": Control.SIZE_EXPAND_FILL
			}),
		]),
	])
