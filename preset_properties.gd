extends Node

#	Presets are like css classes
#
#	Goo.center({"preset":"app"},[
#		Goo.rich_label({
#			"text":"[center][wave]Goodoo[/wave][/center]"
#		}),
#	])

func initialize_presets():
	Goo.presets = {}
	
	var app = CenterContainer.new()
	app.anchors_preset = Control.PRESET_WIDE
	Goo.add_preset("app", app)
