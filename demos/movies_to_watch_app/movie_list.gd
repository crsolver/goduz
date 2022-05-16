extends CustomComponent
class_name MovieList

var list_container:ScrollContainer
var scroll_bar:ScrollBar

func _init(_input={}):
	super(_input)

func ready():
	list_container = get_control("list_container")
	scroll_bar = list_container.get_v_scroll_bar()

func scroll_end():
	var tween = list_container.create_tween()
	tween.tween_property(list_container, "scroll_vertical", 9000, 0.3).set_trans(Tween.EASE_IN_OUT)

func updated():
	scroll_end()

func render():
	var items = []
	for item in input.items:
		items.append(MovieItem.new({"text":item.todo}))
	
	return\
	Goo.scroll({
		"id":"list_container",
		"clip_contents": true,
		"size_flags_horizontal": Control.SIZE_FILL,
		"size_flags_vertical": Control.SIZE_EXPAND_FILL,
		},[
			Goo.vbox({
				"size_flags_vertical": Control.SIZE_EXPAND_FILL,
				"size_flags_horizontal": Control.SIZE_EXPAND_FILL,
			},items)
		])
