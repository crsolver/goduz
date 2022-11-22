class_name TodoList extends Component

func view():
	return\
	scrollbox({preset="expand"}, [
		vbox({preset="expand-h", list=props.items.hash()}, 
			props.items.map(func(item): return\
				TodoItem.new({
					data=item, 
					key=item.id,
					on_todo_toggled=props.on_todo_toggled
				})
			)
		)
	])

