class_name MaxSizeBox extends Component

var mg: MarginContainer

func _init(p:Dictionary, content:BaseComponent):
	p.content = content
	super(p)

func component_ready():
	mg.resized.connect(fix)
	fix()

func fix():
	var margin_value = Vector2((mg.size.x - props.size.x)/2.0, (mg.size.y-props.size.y)/2.0)
	print(margin_value)
	mg.add_theme_constant_override("margin_top", margin_value.y)
	mg.add_theme_constant_override("margin_left", margin_value.x)
	mg.add_theme_constant_override("margin_bottom", margin_value.y)
	mg.add_theme_constant_override("margin_right", margin_value.x)


func view():
	return\
	margin({ref="mg", preset="full"}, [
		props.content
	])
