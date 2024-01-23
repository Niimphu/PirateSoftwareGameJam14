extends VBoxContainer

func set_text(input: String, response: String, error: bool = false):
	$InputHistory.text = " > " + input
	if error:
		$Response/ResponseHistory.set("theme_override_colors/font_color", "cc0000")
	if response == "":
		remove_child($Response)
	else:
		$Response/ResponseHistory.text = response
