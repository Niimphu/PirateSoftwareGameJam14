extends Node

@onready var chat = $"../Columns/Info/MarginContainer/Rows/MarginContainer/Chat/ChatScroll/ChatLog"
@onready var scroll = $"../Columns/Info/MarginContainer/Rows/MarginContainer/Chat/ChatScroll"
@onready var scrollbar = scroll.get_v_scroll_bar()

var welcome_message = PackedStringArray(["Howdy, Mr Hackeroo.", "Hey hey hey, what's up, Hacker?",
	"Top of the morning to ya, Hacker.", "Good to see you, Hacker."])
var welcome_option = PackedStringArray(["Stay hydrated! ;)", "Feeling well rested?",
	"Remember: good posture is important!", "Lovely weather today, isn't it?"] )
var welcome_message_count = welcome_message.size()
var welcome_option_count = welcome_option.size()

var task_prefix = PackedStringArray(["Ok, now ", "Next, ", "Now, ", "You need to ", "Time to ", "Nice! Now ",
	"Seems we gotta ", "Okay, after that ", "And then ", "Then, "])
var task_prefix_count = task_prefix.size()

var typing = false
var first_message = true

const Message = preload("res://scenes/objects/ChatMessage.tscn")


func _ready():
	scrollbar.connect("changed", scrollbar_changed)
	EventBus.game_start.connect(start_game)
	EventBus.game_end.connect(end_game)


func start_game():
	first_message = true
	type_message("Initiating system breach...")
	await get_tree().create_timer(1).timeout
	type_message("Aaaand we're in. Remember, I'll give you the commands to type in the terminal "
		+ yellow("in yellow."))

func end_game():
	if System.score >= 100:
		type_message("Well done, Hacker. We've spread to another network.")
	else:
		type_message("Unfortunately, the hack was not successful, but we can't get them all.")

func system_start():
	display_welcome_message()


func display_welcome_message():
	var message = welcome_message[randi() % welcome_message_count]
	if randi() % 3 == 0:
		message += " " + welcome_option[randi() % welcome_option_count]
	type_message(message)


func print_task(task: String):
	var task_message: String
	if first_message:
		task_message = "First, " + yellow(task) + "."
		first_message = false
	else:
		task_message = task_prefix[randi() % task_prefix_count] + yellow(task) + "."
	type_message(task_message)


func yellow(text: String) -> String:
	return "[color=yellow]" + text + "[/color]"


func type_message(message_text):
	
	if chat.get_child_count() > 0:
		var previous_message = chat.get_child(get_child_count() - 1)
		previous_message.text = "[color=#949494]" + remove_colour(previous_message.text) + "[/color]"
	
	var message = Message.instantiate()
	chat.add_child(message)
	message.new_message(message_text)
	
	typing = true
	message.typing_finished.connect(finished_typing)



func remove_colour(input_str: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(input_str, "")



func finished_typing():
	typing = false


func scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value


