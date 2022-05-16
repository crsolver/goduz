extends Control

var app

func _ready():
	PresetProperties.initialize_presets()
	app = App.new()
	add_child(app)
	Goodoo.render(self.get_node("App"), app)

func _on_reload_button_pressed():
	app.queue_free()
	get_node("App").get_children()[0].queue_free()
	PresetProperties.initialize_presets()
	app = App.new()
	add_child(app)
	Goodoo.render(self.get_node("App"), app)