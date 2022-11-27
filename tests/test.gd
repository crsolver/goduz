extends BaseRootComponent


func view():
	return\
	scrollbox({preset="full"}, [
		vbox({preset="expand-h"}, [
			BasicToBasicInterchange.new(),
			ComponentToComponentInterchange.new(),
			ComponentToBasicInterchange.new()
		])
	])
