class_name TodosApp extends BaseRootComponent

var line_edit_node

func _init():
	super()
	state.todos = [
		{id=0, text="Learn Godot", completed=true},
		{id=1, text="Learn Goduz", completed=false},
	]

func add_todo(t:String):
	if t.strip_edges() == "": return
	state.todos.append({
		id = state.todos.size(),
		text = t,
		completed = false
	})
	line_edit_node.text = ""

func toggle_todo(id):
	var todo = state.todos.filter(func(item):return item.id == id)[0]
	todo.completed = not todo.completed

func view():
	return \
	control({preset="full"}, [
		color_rect({preset="full", color=Color.BLACK}),
		margin({preset="full"}, [
			vbox({preset="expand"}, [
				TodoInfo.new({todos=state.todos}),
				TodoList.new({items=state.todos, on_todo_toggled=toggle_todo}),
				line_edit({
					assign_to="line_edit_node",
					placeholder_text="New +",
					on_text_submitted=add_todo
				})
			])
		])
	])
