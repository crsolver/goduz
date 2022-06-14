extends CustomComponent

class_name App

func _init():
	super("app")

func gui():
	return\
	Goo.control({preset="full"},[
		Goo.vbox({preset="full"},[
			Goo.button({preset="fill",text="button"}),
			Goo.button({preset="fill",text="button"})
#			Goo.rich_label({
#				preset="rich",
#				text="[center][wave]Goodoo[/wave][/center]"
#			})
		])
	])
