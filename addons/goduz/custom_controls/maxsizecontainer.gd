class_name MaxSizeContainer extends MarginContainer

var max_size = Vector2(0,0)
var _updated = false

func _ready():
	resized.connect(_on_resized)

func _process(delta):
	_updated = false

func fix():
	if _updated == true: return
	
	var m_left
	var m_right
	var m_top
	var m_bottom
	
	if size.x < max_size.x:
		m_left = 0
		m_right = 0
	else:
		m_left = (size.x - max_size.x)/2
		m_right = (size.x - max_size.x)/2
	
	if size.y < max_size.y:
		m_top = 0
		m_bottom = 0
	else:
		m_top = (size.y - max_size.y)/2
		m_bottom = (size.y - max_size.y)/2
	
	add_theme_constant_override("margin_left", m_left)
	add_theme_constant_override("margin_right", m_right)
	add_theme_constant_override("margin_top", m_top)
	add_theme_constant_override("margin_bottom", m_bottom)

	_updated = true

func _on_resized():
	fix()
