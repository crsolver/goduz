extends BaseRootComponent
class_name RootComponent

func _init():
	super()
#	presets_path = "res://presets.tscn"

func view():
	return\
	control({preset="full"}, [
		box({
			preset="center", 
			custom_minimum_size=Vector2(100,100),
			background_color=Color.LIGHT_CORAL,
			border_width=6,
			border_color=Color.BLACK,
			border_radius=60
		}, [
			label({preset="text-align-center-h", text="box"})
		])
	])
