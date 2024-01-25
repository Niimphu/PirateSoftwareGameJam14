extends Node

var type_delay = 30
var score_depletion_rate = 2000
var in_game = false
var score = 0
var time: int

func start_game():
	EventBus.game_start.emit()
	time = score_depletion_rate
	var tween = get_tree().create_tween()
	tween.tween_property(System, "score", 50, 3)
	in_game = true


func _process(_delta):
	if in_game:
		if time == 0:
			time = score_depletion_rate
			score -= 1
		else:
			time -= 1


func end_game():
	in_game = false
	EventBus.game_end.emit()
