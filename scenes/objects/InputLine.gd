extends LineEdit

@onready var clear_placeholder = true
@onready var attacks = $"../../../../../../../../Attacks"

var chars = "abcdefghjklmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789"#
var chars_size = chars.length()

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



func _on_attack_delay_timeout():
	if attacks.type_attack:
		text += chars[randi() % chars_size] + chars[randi() % chars_size]
		if randi() % 2 == 0:
			text += chars[randi() % chars_size]
		set("caret_column", 50)
		$Click.play


func _on_text_changed(_new_text):
	$Click.pitch_scale = randf_range(0.8, 1.2)
	$Click.play()
