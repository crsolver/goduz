class_name TodoInfo extends Component

func _init(p:Dictionary):
	super(p)

func view():
	var total = props.todos.size()
	var completed = props.todos.filter(func(i):return i.completed).size()
	
	return\
	hbox({preset="expand-h"},[
		label({preset="expand-h", text="To do list"}),
		label({text=str(completed) + "/" + str(total)})
	])
