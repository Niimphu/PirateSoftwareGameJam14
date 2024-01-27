extends Node

var valid_characters = "abcdefghjklmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789"
var valid_character_count = valid_characters.length()

func generate_code():
	var code = ""
	for i in 10:
		code += valid_characters[randi() % valid_character_count]
	return code

