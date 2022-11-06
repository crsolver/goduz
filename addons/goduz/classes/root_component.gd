extends BaseRootComponent
class_name RootComponent

func _init():
	super()
#	presets_path = "res://presets.tscn"

func view():
	return\
	control({preset="full"}, [
		List.new()
	])
