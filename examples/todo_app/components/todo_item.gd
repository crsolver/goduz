class_name TodoItem extends Component

func _init(p:Dictionary):
	super(p)

func toggle_todo():
	call_method(props.on_todo_toggled, [props.data.id])


func view():
	return\
	panel_container({},[
		hbox({preset="expand-h"},[
			rich_label({
				preset="expand",
				bbcode_enabled=true,
				text= ("[color=#00cf57][s]%s[/s][/color]" if props.data.completed else "%s") % props.data.text}),
			button({
				text= "[X]" if props.data.completed else "[  ]",
				on_pressed=toggle_todo,
				action_mode=BaseButton.ACTION_MODE_BUTTON_PRESS
			})
		])
	])
