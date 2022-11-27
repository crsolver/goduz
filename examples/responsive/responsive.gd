class_name CustomBox extends Component

var c: Control
var content: Array

func _init(props:Dictionary, content: Array):
	super(props)
	self.content = content
	state.horizontal = true

func _process(delta):
	if c.size.x < props.horizontal and state.horizontal:
		state.horizontal = false
		update_view()
	elif c.size.x >= props.horizontal and not state.horizontal:
		state.horizontal = true
		update_view()

func view():
	return control({preset="full", ref="c"},[
		hbox({preset="full", id="container"}, content) if state.horizontal else vbox({preset="full", id="container"}, content)
	])
