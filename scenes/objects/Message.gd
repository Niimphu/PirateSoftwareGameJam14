extends VBoxContainer

func set_text(message: String, error: bool = false):
	if error:
		$Column/Message.set("theme_override_colors/font_color", "ff0000")
	$Column/Message.text = message
