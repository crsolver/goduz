extends BaseRootComponent


func view() -> BasicComponent:
	return control({preset="full"}, [
		CustomBox.new({horizontal=300}, [
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
			button({text="button"}),
		])
	])
