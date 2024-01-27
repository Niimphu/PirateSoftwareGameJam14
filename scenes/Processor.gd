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
			"manual":
				return manual()
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
			System.start_game()
			return ""
		"status":
			return "No session in progress"
		"end":
			return "No session in progress"
		_:
			return "Unknown command \"" + first_word + "\". Type \"commands\" to show currently available commands"


func process_game_command(words: PackedStringArray) -> String:
	var first_word = words[0].to_lower()
	
	match first_word:
		"get_code":
			return new_code(words[1])
		"redeem":
			return $"../Attacks".redeem_code(words[1])
		"status":
			return $"../Attacks".status()
		"end":
			System.end_game()
			return ""
		_:
			return ""


func new_code(subsystem: String) -> String:
	match subsystem.to_lower():
		"input":
			System.current_code = $CodeGenerator.generate_code()
			System.code_system = "input"
			return "New code: " + System.current_code + "\nCode is valid until next \"get_code\" usage"
		"network":
			System.current_code = $CodeGenerator.generate_code()
			System.code_system = "network"
			return "New code: " + System.current_code + "\nCode is valid until next \"get_code\" usage"
		"ai":
			System.current_code = $CodeGenerator.generate_code()
			System.code_system = "ai"
			return "New code: " + System.current_code + "\nCode is valid until next \"get_code\" usage"
		"memory":
			System.current_code = $CodeGenerator.generate_code()
			System.code_system = "memory"
			return "New code: " + System.current_code + "\nCode is valid until next \"get_code\" usage"
		"processor":
			System.current_code = $CodeGenerator.generate_code()
			System.code_system = "processor"
			return "New code: " + System.current_code + "\nCode is valid until next \"get_code\" usage"
		_:
			return "Error: get_code: invalid subsystem"




func commands():
	var command_text = "Available commands:\n manual: display the company guidebook on-screen\n"
	
	if not System.in_game:
		command_text += " start: begin a new hacking session
		 clear: clear terminal history
		 fullscreen: toggle fullscreen
		 reboot: restart the game
		 quit: close the game\n"
	
	else:
		command_text += " status: display subsystem status
		 get_code <subsystem name>: get a code to fix a subsystem
		 redeem <code>: uses a generated code
		 end: end the current hacking session\n"
	
	command_text += " commands: show currently available commands\n"
	return command_text


func manual():
	var manual_text = "ProxyHQ: Employee's Handbook
		Your mission: hack public networks and infect them with our virus to spread it far and wide >:)
		- Type \"start\" to begin a new hacking session, or \"commands\" at any time for more commands
		- Your AI assistant will provide you with your Hacker Commands in yellow, simply type them in the terminal
		- Type \"status\" during a session to view subsystems
		- If the network is attacking your subsystems, type \"get_code\" followed by the subsystem's name to get a code from ViralHQ
		- Type \"redeem\" followed by the code to use it and stop the attack
		- Scroll with mousewheel to browse terminal history"
	
	return manual_text


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


