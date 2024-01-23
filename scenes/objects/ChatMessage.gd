extends RichTextLabel

var time = 0

signal typing_finished

func new_message(message: String):
	text = message
	visible_characters = 0

func _process(_delta):
	if visible_ratio >= 1:
		typing_finished.emit()
		set_process(false)
	else:
		if time == 0:
			time = System.TYPE_DELAY
			visible_characters += 1
		else:
			time -= 1

