extends Node

func dict_to_json(dict):
	var json = JSON.new()
	return json.stringify(dict,"\t",false)
