extends CustomComponent

class_name MoviesApp

var http:HTTPRequest


func _init():
	#Always call super()
	super()
	state = {"items":[]}

func ready():
	# Use ready for http request or timers
	http = HTTPRequest.new()
	# When nodes like HTTPRequest or Timer are created they have to be added to control
	control.add_child(http)
	http.request_completed.connect(http_request_completed)
	var error = http.request("https://ghibliapi.herokuapp.com/films")
	print("Requesting movies from https://ghibliapi.herokuapp.com/films...")
	if error != OK:
		print("An error occurred in the HTTP request.")


func http_request_completed(_result, _response_code, _headers, _body):
	print("Request completed")
	var json = JSON.new()
	json.parse(_body.get_string_from_utf8())
	var movies = json.get_data()
	var new_state = state.duplicate(true) #Work with a duplicate when updating the state
	if movies:
		for movie in movies:
			new_state.items.append({"todo":movie.title + " (from http request)"})
		set_state(new_state)


func handle_add_movie(todo):
	var new_state = state.duplicate(true) #Work with a duplicate when updating the state
	new_state.items.append({"todo":todo})
	set_state(new_state)


func render():
	return\
	Goo.margin({"anchors_preset": Control.PRESET_WIDE,"const_margin_all":20},[
		Goo.vbox({},[
			Goo.label({"text":"Movies to watch"}),
			MovieList.new(state),
			UserInput.new({"onSubmit":handle_add_movie})
		])
	])
