extends Control

@onready var processor = $Processor
@onready var history = $Columns/Terminal/MarginContainer/Rows/Output/MarginContainer/HistoryScroll/History
@onready var input_box = $Columns/Terminal/MarginContainer/Rows/Input/CommandLine/InputLine
@onready var scroll = $Columns/Terminal/MarginContainer/Rows/Output/MarginContainer/HistoryScroll
@onready var scrollbar = scroll.get_v_scroll_bar()

const Reply = preload("res://scenes/objects/InputResponse.tscn")
const Message = preload("res://scenes/objects/Message.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scrollbar.connect("changed", scrollbar_changed)
	processor.connect("clear_screen", clear_screen)
	$Fade.fade_in()


func _on_input_line_text_submitted(new_text):
	if new_text.is_empty():
		return
	new_response(new_text)


func new_output(input: String):
	var error = input.begins_with("Error")
	
	var message = Message.instantiate()
	message.set_text(input, error)
	history.add_child(message)


func new_response(input: String):
	var response = processor.process_input(input)
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
	new_output("Systems now online")
	get_tree().create_timer(1.0).timeout.connect(start_session)


func start_session():
	$ChatBot.begin()
	input_box.grab_focus()
	input_box.set("placeholder_text", "Type here")


func _on_animation_player_animation_finished(_anim_name):
	display_welcome_message()
	
	
func clear_screen():
	for child in history.get_children():
		child.queue_free()

