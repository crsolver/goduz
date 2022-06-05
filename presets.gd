extends Node

#	Presets are predefined properties of control nodes
#	you can define them through code or visually saving a scene with a control node in the visual_presets folder
#	specify the preset for your components
#	
#	Goo.center({"preset":"app"},[
#		Goo.rich_label({
#			"text":"[center][wave]Goodoo[/wave][/center]"
#		}),
#	])

func initialize_presets():
	#label
	var label = Label.new()
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.name = "centeredLabel"
	Goo.create_presets_from_control(label)
