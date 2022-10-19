extends MarginContainer

var stylebox: StyleBoxFlat
var is_ready = false
var panel_container

var margin: int = 0:
	get: return margin
	set(value):
		margin = value
		add_theme_constant_override("margin_top", margin)
		add_theme_constant_override("margin_left", margin)
		add_theme_constant_override("margin_bottom", margin)
		add_theme_constant_override("margin_right", margin)

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

var border_width: int:
	get: return border_width
	set(value):
		if not is_ready: return
		border_width = value
		stylebox.set_border_width_all(value)

var border_radius: int

func _ready():
	is_ready = true
	panel_container = $container
	stylebox = StyleBoxFlat.new()
	panel_container.theme = Theme.new()
	panel_container.theme.set_stylebox("panel", "PanelContainer", stylebox)
	
	for child in get_children():
		if child.name != "container":
			remove_child(child)
			panel_container.add_child(child)
	
	stylebox.bg_color = background_color
	stylebox.border_color = border_color
	stylebox.content_margin_bottom = padding
	stylebox.content_margin_top = padding
	stylebox.content_margin_right = padding
	stylebox.content_margin_left = padding
	
