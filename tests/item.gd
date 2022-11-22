extends Component
class_name Item

func _init(_props):
	super(_props)

func view():
	return \
	center({preset="expand-h"}, [
		label({text=props.text})
	])
