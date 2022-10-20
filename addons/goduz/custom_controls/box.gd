extends PanelContainer

var stylebox: StyleBoxFlat
var is_ready = false

var padding: int = 0:
	get: return padding
	set(value):
		padding = value
		if not is_ready: return 
		stylebox.content_margin_bottom = padding
		stylebox.content_margin_top = padding
		stylebox.content_margin_right = padding
		stylebox.content_margin_left = padding

var background_color:= Color.WHITE:
	get: return background_color
	set(value):
		background_color = value
		if not is_ready: return
		stylebox.bg_color = background_color

var border_color:= Color.WHITE:
	get: return border_color
	set(value):
		border_color = value
		if not is_ready: return
		stylebox.border_color = value

var border_width:= 0:
	get: return border_width
	set(value):
		border_width = value
		if not is_ready: return
		stylebox.set_border_width_all(border_width)

var border_radius:= 0:
	get: return border_radius
	set(value):
		border_radius = value
		if not is_ready: return
		stylebox.set_corner_radius_all(value)

func _ready():
	is_ready = true
	stylebox = StyleBoxFlat.new()
	theme = Theme.new()
	theme.set_stylebox("panel", "PanelContainer", stylebox)
	
	stylebox.bg_color = background_color
	stylebox.border_color = border_color
	stylebox.content_margin_bottom = padding
	stylebox.content_margin_top = padding
	stylebox.content_margin_right = padding
	stylebox.content_margin_left = padding
	stylebox.set_border_width_all(border_width)
	stylebox.set_corner_radius_all(border_radius)
