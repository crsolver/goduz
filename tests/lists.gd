class_name List extends Component

func _init():
	super()
	state.items= ["0", "1", "2", "3", "4"]
#	state.items= ["0"]


func add():
	var i = state.items.size()
#	print("pushing " + str(i))
#	state.items.push_front(str(i))
	print(state.items)
	state.items = ["3", "5"]

func delete():
	state.items.pop_back()

func view(): 
	return \
	vbox({preset="full"}, [
		scrollbox({preset="expand"}, [
			vbox({preset="expand", list=state.items.hash()}, 
				state.items.map(func(item): return Item.new({text=item, key=item}))
			),
		]),
		button({on_pressed=add, text="add"})
	])
