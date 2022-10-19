class_name Tabs extends Component

func view():
	return\
	tabbox({preset="full"},[
		label({name="1", text="1"}),
		label({name="2", text="2"}),
		label({name="3", text="3"}),
	])
