extends Control

@onready var processor = $Processor
@onready var game_manager = $GameManager
@onready var history = $Columns/Terminal/MarginContainer/Columns/Rows/Output/MarginContainer/HistoryScroll/History
@onready var input_box = $Columns/Terminal/MarginContainer/Columns/Rows/Input/CommandLine/InputLine
@onready var scroll = $Columns/Terminal/MarginContainer/Columns/Rows/Output/MarginContainer/HistoryScroll
@onready var scrollbar = scroll.get_v_scroll_bar()

const Reply = preload("res://scenes/objects/InputResponse.tscn")
const Message = preload("res://scenes/objects/Message.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scrollbar.connect("changed", scrollbar_changed)
	processor.connect("clear_screen", clear_screen)
	$Fade.fade_in()
	get_tree().create_timer(10).timeout.connect(bot_help)
	EventBus.game_start.connect(start_game)
	EventBus.game_end.connect(end_game)


func bot_help():
	if System.in_game:
		return
	if history.get_child_count() < 3:
		var tips = PackedStringArray(["You can type \"commands\" in the terminal to see currently available commands.",
			"Type \"manual\" in the terminal to bring up the manual.",
			"Try typing something in the terminal."])
		$ChatBot.type_message(tips[randi() % 3])


func _on_input_line_text_submitted(input):
	if input.is_empty():
		return
	var response: String
	response = processor.process_input(input)
	if response == "":
		response = game_manager.input_submitted(input)
	print_response(input, response)


func new_output(input: String):
	var error = input.begins_with("Error")
	
	var message = Message.instantiate()
	message.set_text(input, error)
	history.add_child(message)


func print_response(input: String, response: String):
	if response == " ":
		return
	var error = response.begins_with("Error")

	var reply = Reply.instantiate()
	reply.set_text(input, response, error)
	history.add_child(reply)


func scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value


func display_welcome_message():
	new_output("Code Viral Terminal")
	get_tree().create_timer(1.0).timeout.connect(print_start)


func print_start():
	new_output("Copyright Viral Co. 2074")
	get_tree().create_timer(1.0).timeout.connect(start_session)


func start_session():
	$ChatBot.system_start()
	input_box.grab_focus()
	input_box.set("placeholder_text", "Type here")


func _on_animation_player_animation_finished(_anim_name):
	display_welcome_message()
	
	
func clear_screen():
	for child in history.get_children():
		child.queue_free()


func start_game():
	new_output("Session start")


func end_game():
	var end_message: String
	if (System.score >= 100):
		end_message = "System hack complete\n"
	else:
		end_message = "User ejected from the system\n"
	end_message += " Tasks complete: " + str(System.successful_tasks) + "\n"
	end_message += " Codes redeemed: " + str(System.codes_redeemed) + "\n"
	end_message += " Total successful hacks: " + str(System.successful_hacks)
	new_output(end_message)

