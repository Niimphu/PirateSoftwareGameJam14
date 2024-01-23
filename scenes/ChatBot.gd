extends Node

@onready var chat = $"../Columns/Info/MarginContainer/Rows/MarginContainer/Chat/ChatScroll/ChatLog"
@onready var scroll = $"../Columns/Info/MarginContainer/Rows/MarginContainer/Chat/ChatScroll"
@onready var scrollbar = scroll.get_v_scroll_bar()

var welcome_message = PackedStringArray(["Welcome back, Hacker.", "Salutations, Hacker.",
	"Good evening, Hacker.", "Good to see you, Hacker."])
var welcome_option = PackedStringArray(["Remember to stay hydrated.", "Are you well rested?",
	"I hope you have been maintaining good posture."] )
var welcome_message_count = welcome_message.size()
var welcome_option_count = welcome_option.size()

var typing = false

const Message = preload("res://scenes/objects/ChatMessage.tscn")


func _ready():
	scrollbar.connect("changed", scrollbar_changed)


func begin():
	display_welcome_message()


func _process(_delta):
	pass


func display_welcome_message():
	var message = welcome_message[randi() % welcome_message_count]
	if randi() % 4 == 0:
		message += " " + welcome_option[randi() % welcome_option_count]
	type_message(message)
	#await get_tree().create_timer(2).timeout
	#type_message("You can type \"commands\" to show a list of currently available commands.")


func type_message(message_text):
	var message = Message.instantiate()
	chat.add_child(message)
	message.new_message(message_text)
	
	typing = true
	message.typing_finished.connect(finished_typing)


func finished_typing():
	typing = false


func scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value


