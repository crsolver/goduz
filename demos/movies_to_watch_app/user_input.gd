extends CustomComponent
class_name UserInput

var line_edit:LineEdit

func _init(_input):
	super(_input)

func ready():
	# a control node can be accesed with get_control(id)
	line_edit = get_control("input")


func handle_text_submitted(text):
	if text == "": return
	input.onSubmit.call(text)
	line_edit.text = ""


func on_button_click():
	if line_edit.text == "": return
	input.onSubmit.call(line_edit.text)
	line_edit.text = ""


func render():
	return\
	Goo.hbox({},[
		Goo.line_edit({
			"size_flags_horizontal": Control.SIZE_EXPAND_FILL,
			"id":"input", # a control node can be accesed with get_control(id)
			"on_text_submitted":handle_text_submitted}),
		Goo.button({"text":"+", "on_pressed":on_button_click})
	])
