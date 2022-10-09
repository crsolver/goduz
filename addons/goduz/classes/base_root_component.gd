class_name BaseRootComponent
extends Component

@export
var show_reload_button = true

@onready
var reload_b_scene = load("res://addons/goduz/reload_components_button.tscn")

var vbox
var root_control:Control
var presets_path


func _ready():
	vbox = VBoxContainer.new()
	vbox.name ="VBoxContainer"
	if show_reload_button:
		var reload_b = reload_b_scene.instantiate() as Button
		vbox.add_child(reload_b)
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	call_deferred("add_sibling", vbox)
	mount()

func mount():
	Gui.initialize_presets(presets_path)
	var rc = Control.new()

	root_control = rc
	vbox.add_child(rc)
	rc.size_flags_vertical = rc.SIZE_EXPAND_FILL
	Goduz.render(rc, self, self)

func update_view():
	var next = view()
	Goduz.diff(self.get_view(), next)
	component_updated()
