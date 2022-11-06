extends Component
class_name GoduzCounter

# Called when the component is created. Use it to initialize the state.
func _init():
	super()
	state.count = 0

# LIFECYCLE METHODS_________________________________________________________________________________
# Called after the component has been rendered to the screen the first time.
func component_ready():
	var c = get_control("animate")
	var tween = c.create_tween()
	tween.set_parallel(true)
	tween.tween_property(c, "modulate:a", 1.0, 0.5).from(0.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(c, "position:y", c.position.y, 0.5).from(c.position.y+50.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# load textures when the component is ready to avoid loading them every time the state changes
	get_control("logo").texture = load("res://addons/goduz/assets/goduz_logo.png")

# Called after the view of this component has been updated.
func component_updated():
	pass

# Called before the component is destroyed.
func component_will_die():
	pass


# COMPONENT LOGIC___________________________________________________________________________________
func decrement(): state.count -= 1 

func increment(): state.count += 1

# VIEW_____________________________________________________________________________________________
func view(): 
	return\
	control({preset="full"}, [# Use preset="full" to expand BasicComponents (control nodes).
		color_rect({color=Color.html("#1d2229"), preset="full"}),
		center({preset="full", id="animate"},[
			vbox({},[
				texture_rect({id="logo", stretch_mode = 3}),
				label({text="Goduz", preset="expand-h text-align-center-h"}),
				hbox({preset="expand"},[ # Use preset="expand" to expand BasicComponents (control nodes) that are children of containers.
					my_button(decrement, "-"),
					label({preset="expand-h text-align-center-h", text=str(state.count)}),
					my_button(increment, "+")
				])
			])
		])
	])

# Reusable component
func my_button(method: Callable, text: String): 
	return\
	button({
		text=text,
		on_pressed=method, # signals begin with on_
		custom_minimum_size=Vector2(20,30),
		preset="cursor-pointing" # Goduz includes some useful presets, see the the method initialize_presets(path) in addons/goduz/singletons/gui to see the included presets and add your own.
	})
