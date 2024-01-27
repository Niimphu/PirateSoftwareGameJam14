extends Node

var type_delay = 2
var score_depletion_rate = 1600
var in_game = false
var score = 1
var successful_tasks: int
var codes_redeemed: int
var time: int
var successful_hacks = 0

var current_code = ""
var code_system = ""


func start_game():
	in_game = true
	successful_tasks = 0
	codes_redeemed = 0
	EventBus.game_start.emit()
	time = score_depletion_rate
	var tween = get_tree().create_tween()
	tween.tween_property(System, "score", 40, 3)


func end_game():
	EventBus.game_end.emit()


func _process(_delta):
	if in_game:
		if score < 0 or score >= 100:
			in_game = false
			EventBus.game_end.emit()
			if score >= 100:
				successful_hacks += 1
			score = 0
		elif time == 0:
			time = score_depletion_rate
			score -= 1
		else:
			time -= 1


func scored(scoring_string: String):
	score += scoring_string.length() / 2
	successful_tasks += 1
	if successful_tasks == 3:
		EventBus.start_attacking.emit()

