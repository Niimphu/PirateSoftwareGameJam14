extends Node

@onready var flash = $"../Columns/Terminal/MarginContainer/Columns/Rows/Flash"

var type_attack = false
var silly_case = false
var reverse_attack = false
var slow_type = false
var long_commands = false
var inactive_attacks = PackedStringArray(["type_attack", "silly_case", "reverse_attack", "slow_type", "long_commands"])


func _ready():
	EventBus.game_end.connect(end_game)
	EventBus.start_attacking.connect(start_attacks)


func status():
	var status_string = "Subsystem status:\n"
	status_string += "Input: " + ("OK\n" if !type_attack else "under attack\n")
	status_string += "Network: " + ("OK\n" if !silly_case else "under attack\n")
	status_string += "AI: " + ("OK\n" if !reverse_attack else "under attack\n")
	status_string += "Memory: " + ("OK\n" if !slow_type else "under attack\n")
	status_string += "Processor: " + ("OK\n" if !long_commands else "under attack\n")
	return status_string


func new_attack():
	var attack_count = inactive_attacks.size()
	var attack = inactive_attacks[randi() % attack_count]
	
	if attack:
		inactive_attacks.remove_at(inactive_attacks.find(attack))
		flash.play("flash")
		$Beep.play()
		match attack:
			"type_attack":
				type_attack = true
			"silly_case":
				silly_case = true
			"reverse_attack":
				reverse_attack = true
			"slow_type":
				slow_type = true
				System.type_delay = 10
			"long_commands":
				long_commands = true


func redeem_code(code: String) -> String:
	if System.current_code == "" or code != System.current_code:
		return "Invalid code"
	System.current_code = ""
	System.codes_redeemed += 1
	match System.code_system:
		"input":
			type_attack = false
			inactive_attacks.append("type_attack")
			System.code_system = ""
			return "Input drivers reinstalled"
		"network":
			silly_case = false
			inactive_attacks.append("silly_case")
			System.code_system = ""
			return "Network configuration flushed"
		"ai":
			reverse_attack = false
			inactive_attacks.append("reverse_attack")
			System.code_system = ""
			return "AI reset"
		"memory":
			slow_type = false
			inactive_attacks.append("slow_type")
			System.type_delay = 2
			System.code_system = ""
			return "Memory cleansed"
		"processor":
			long_commands = false
			inactive_attacks.append("long_commands")
			System.code_system = ""
			return "Processor "
		_:
			return "Error"



func end_game():
	type_attack = false
	silly_case = false
	reverse_attack = false
	slow_type = false
	long_commands = false
	System.type_delay = 2


func start_attacks():
	new_attack()
	$AttackDelay.start()


func _on_attack_delay_timeout():
	if System.in_game and System.successful_tasks > 3 and inactive_attacks.size() > 0:
		new_attack()
