extends ColorRect

func fade_in():
	set("mouse_filter", MOUSE_FILTER_STOP)
	$AnimationPlayer.play("fade_in")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		set("mouse_filter", MOUSE_FILTER_IGNORE)
