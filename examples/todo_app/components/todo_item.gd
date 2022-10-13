class_name TodoItem extends Component

func _init(p:Dictionary):
	super(p)

func toggle_todo():
	call_method(props.on_todo_toggled, [props.data.id])

func view():
	return\
	panel_container({},[
		hbox({preset="expand-h"},[
			rich_label({preset="expand", text=props.data.text}),
			button({
				text= "[X]" if props.data.completed else "[  ]",
				on_pressed=toggle_todo
			})
		])
	])
