extends BaseRootComponent


func view():
	return\
	scroll_container({preset="full"}, [
		vbox({preset="expand-h"}, [
			BasicToBasicInterchange.new(),
			ComponentToComponentInterchange.new(),
			ComponentToBasicInterchange.new()
		])
	])
