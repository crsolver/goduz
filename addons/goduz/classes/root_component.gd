extends BaseRootComponent
class_name RootComponent

func _init():
	super()
#	presets_path = "res://presets.tscn"

func view():
	return\
	control({preset="full"}, [
		MaxSizeBox.new({size=Vector2(300,300)},
			panel_container({preset="expand"}, [
				label({preset="expand-h", wordwrap_mode=3, text="jasdf asdjf aosdjfaosdfj asodf aosdf apsod"})
			])
		)
	])
