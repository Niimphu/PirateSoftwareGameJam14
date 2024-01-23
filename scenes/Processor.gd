extends Node

@onready var shutters = $"../ShutDown/AnimationPlayer"

signal clear_screen

func process_input(input: String) -> String:
	var words = input.split(" ", false)
	if words.size() == 0:
		return "Error"
	
	var output: String
	output = process_universal_command(words)
	if output != "":
		return output
	elif !System.in_game:
		return process_menu_command(words)
	else:
		return process_game_command(words)


func process_universal_command(words: PackedStringArray) -> String:
		var first_word = words[0].to_lower()
		match first_word:
			"commands":
				return commands()
			"help":
				return help()
			"clear":
				clear_screen.emit()
				return " "
			"fullscreen":
				return "Fullscreen " + "on" if toggle_fullscreen() else "off"
			"reboot":
				shut_down(true)
				return "Rebooting..."
			"quit":
				shut_down()
				return "Quitting..."
			_:
				return "" 


func process_menu_command(words: PackedStringArray) -> String:
	var first_word = words[0].to_lower()
	
	match first_word:
		"start":
			return start()
		"end":
			return "No session in progress"
		_:
			return "Unknown command \"" + first_word + "\". Type \"commands\" to show currently available commands"


func process_game_command(words: PackedStringArray) -> String:
	var first_word = words[0].to_lower()
	
	match first_word:
		"end":
			System.in_game = false
			return "Session terminated"
		_:
			return "Error: command not found"


func commands():
	var command_text = "Available commands:\n"
	
	if not System.in_game:
		command_text += " start: begin a new hacking session\n"
	
	else:
		command_text += " status: display system status
		 end: end the current hacking session\n"
	
	command_text += " clear: clear terminal history
	 fullscreen: toggle fullscreen
	 reboot: restart the game
	 quit: close the game"
	return command_text


func help():
	var help_text = "Manual:\n"
	
	help_text += ""
	
	return help_text


func toggle_fullscreen() -> bool:
	var mode = DisplayServer.window_get_mode()
	var fullscreen: bool
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		mode = DisplayServer.WINDOW_MODE_WINDOWED
		fullscreen = false
	else:
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		fullscreen = true
	DisplayServer.window_set_mode(mode)
	return fullscreen


func shut_down(restart: bool = false):
	shutters.play("shut_down")
	if restart:
		get_tree().create_timer(1.5).timeout.connect(reboot)
	else:
		get_tree().create_timer(1.5).timeout.connect(quit)


func reboot():
	get_tree().reload_current_scene()


func quit():
	get_tree().quit()


func start() -> String:
	System.in_game = true
	return "Session start"

