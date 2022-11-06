extends Component
class_name Item

func _init(_props):
	super(_props)

func component_ready():
	print("item " + key + " ready")

func component_updated():
	print("item" + key + " updated")

func component_will_die():
	print("item "+ key + " will die")

func view():
	return \
	center({preset="expand-h"}, [
		label({text=props.text})
	])
