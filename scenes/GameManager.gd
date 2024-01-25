extends Node

@onready var ChatBot = $"../ChatBot"
@onready var Processor = $"../Processor"
@onready var RWG = $WordGenerator
@onready var progress = $"../Columns/Terminal/MarginContainer/Columns/ProgressBar"

var expected_input = ""
var expected_output = ""
var complete_message = ""


func _ready():
	EventBus.game_start.connect(start_game)
	EventBus.game_end.connect(end_game)


func new_task():
	generate_task()
	ChatBot.print_task(expected_input)


func input_submitted(input_text: String) -> String:
	if expected_output == "":
		return " "
	match input_text:
		"":
			return ""
		expected_input:
			expected_input = ""
			return complete_message
		_:
			return ""
		

func generate_task():
	var task = RWG.random_action()
	expected_output = task[0]
	expected_input = expected_output
	complete_message = task[1]


func _on_next_task_timeout():
	if expected_input == "":
		new_task()


func start_game():
	await get_tree().create_timer(3).timeout
	$NextTask.start()


func end_game():
	$NextTask.stop()
	expected_input = ""
	expected_output = ""


