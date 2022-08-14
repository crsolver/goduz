extends Component
class_name Counter
# Author: Andres Gamboa

# Called when the component is created. Use it to initialize the state.
func _init():
	super("counter") # Pass a string to identify objects of this class
	state = {
		count = 0
	}


# LIFECYCLE METHODS_________________________________________________________________________________
# Called after the component has been rendered to the screen the first time.
func component_ready():
	var c = get_control("animate")
	var tween = c.create_tween()
	tween.set_parallel(true)
	tween.tween_property(c, "modulate:a", 1.0, 0.5).from(0.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(c, "position:y", c.position.y, 0.5).from(c.position.y+50.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# Called after the view of this component has been updated.
func component_updated():
	pass

# Called before the component is destroyed.
func component_will_die():
	pass


# COMPONENT LOGIC___________________________________________________________________________________
func increment():
	state.count += 1
	update_view()

func decrement(): 
	state.count -= 1
	update_view()


# VIEW_____________________________________________________________________________________________
func view():
	return\
	Gui.control({preset="full"}, [# Use preset="full" to expand BasicComponents (control nodes).
		Gui.color_rect({color=Color.html("#1d2229"), preset="full"}),
		Gui.center({preset="full", id="animate"},[
			Gui.vbox({},[
				Gui.texture_rect({texture=load("res://addons/goduz/assets/goduz_logo.png"), stretch_mode = 3}),
				Gui.label({text="Goduz", preset="expand-h text-align-center-h"}),
				Gui.hbox({preset="expand"},[ # Use preset="expand" to expand BasicComponents (control nodes) that are children of containers.
					Gui.button({
						text="-",
						on_pressed=decrement, # signals begin with on_
						custom_minimum_size=Vector2(20,30),
						preset="cursor-pointing" # Goduz includes some useful presets, see the the method initialize_presets(path) in addons/goduz/singletons/gui to see the included presets and add your own.
						}), 
					Gui.label({preset="expand-h text-align-center-h", text=str(state.count)}),
					Gui.button({
						text="+",
						on_pressed=increment, 
						custom_minimum_size=Vector2(20,30),
						preset="cursor-pointing"
					})
				])
			])
		])
	])
