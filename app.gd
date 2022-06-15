extends CustomComponent

class_name App

func _init():
	super("app")

func gui():
	return\
	Goo.control({preset="full"},[
		Goo.center({preset="full"},[
			Goo.rich_label({
				preset="rich",
				text="[center][wave]Goodoo[/wave][/center]"
			})
		])
	])
