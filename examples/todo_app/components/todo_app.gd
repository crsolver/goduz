class_name TodosApp extends BaseRootComponent

func _init():
	super()
	state.todos = [
		{id=0, text="Learn Godot", completed=true},
		{id=1, text="Learn Goduz", completed=false}
	]

func add_todo(t):
	t = t.strip_edges()
	if t == "": return
	state.todos.append({
		id = state.todos.size(),
		text = t,
		completed = false
	})

func toggle_todo(id):
	var todo = state.todos.filter(func(item):return item.id == id)[0]
	todo.completed = not todo.completed

func view():
	return \
	control({preset="full"}, [
		color_rect({preset="full", color=Color.BLACK}),
		margin({preset="full"}, [
			vbox({preset="expand"}, [
				TodoList.new({items=state.todos, on_todo_toggled=toggle_todo}),
				line_edit({
					placeholder_text="New +",
					on_text_submitted=add_todo
				})
			])
		])
	])
