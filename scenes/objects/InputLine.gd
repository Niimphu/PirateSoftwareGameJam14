extends LineEdit

@onready var clear_placeholder = true


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		grab_focus()


func _on_text_submitted(new_text):
	if (new_text.is_empty()):
		return
	if clear_placeholder:
		placeholder_text = ""
		clear_placeholder = false

	clear()

