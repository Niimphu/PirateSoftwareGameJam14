extends Node

@onready var attacks = $"../../Attacks"

var nonsense_noun = PackedStringArray(["zigzaggle", "quibberish", "snazzlepop", "bibblebop",
	"fizzletwist", "flummoxify", "quibberwacky", "snickerdoodle", "noodleknack",
	"bamboozlery", "zonkeroon", "wobbleflop", "malarkeydoodle", "gibberwump", "flibbertigib",
	"squabbleflap", "razzleblitz", "dinglewobble", "hobblegobble", "quibblequack", "zoobledooble",
	"wrigglejig", "schnozzleworp", "puddlepluck", "blippitybop", "jibberjab", "sprocketoodle", "kookydoodle",
	"mumbojumbo", "zigglywump", "fizzlefazz", "ballyhoozle", "wackydoodle", "snickerwhip", "zippityzap",
	"whimsydoodle", "bibblesnack", "wobblequack", "doodledorf", "snazzlepuff", "quibblesnatch",
	"blitzleflap", "doodlewhack", "sproingledorf", "fizzwobble", "snarklejig", "mufflenoodle",
	"zoobledoodle", "quibblyquack", "dabbledorp", "noodlenap", "bippitybop", "wobblegong",
	"razzlewhack", "snickerflip", "quizzledoodle", "zigglyquack", "wobblefluff", "flibbertoodle",
	"sprocketwack", "snazzlewump", "quibberflop", "noodlejiggle", "zoobledorf", "flippityquack",
	"babbleboop", "zigglewhack", "whirlywump", "dabbledoodle", "quibberfluff", "zippitywhip",
	"wobblegig", "sprocketflap", "malarkeydoodle", "jibberwhip", "noodleflap", "blitzlequack",
	"whimsywhack", "dingleflap", "zonkledorf", "snickerwack", "babblewhack", "fizzlenoodle",
	"quibberdoodle", "zigglywhip", "wobblejig", "bibblesnack", "zooblediddle", "flummoxify", "quibblejig",
	"sprocketquack", "snazzlewump", "noodlequack", "flibbertwump", "doodlewhack", "ziggleflap",
	"wobblewack", "bippitywhack", "whirlywhip", "mumbojumbo", "zippitywump", "quibberflip",
	"snickerdoodle", "babbleflop", "zigglewhack"])

var nonsense_noun_count = nonsense_noun.size()

var verbs = PackedStringArray(["flip", "twist", "press", "push", "pull", "twizzle", "toggle", "rotate",
	"turn", "engage", "activate", "deactivate", "adjust", "set", "configure", "calibrate", "delete",
	"handle", "operate", "toggle", "switch", "flick", "start", "stop", "power", "flush", "shut", "secure",
	"release", "lock", "unlock", "connect", "disconnect", "link", "unlink", "scan", "unzip",
	"bypass", "repair", "maintain", "tweak", "optimise", "compile", "tune", "launch", "parse", "fetch",
	"load", "run", "bind", "stabilise", "reset", "swap", "undo", "merge", "patch", "stitch",
	"sync", "thread", "tie", "fasten", "clamp", "grip", "wrench", "jiggle", "joggle",
	"wiggle", "shake", "vibrate", "jolt", "jounce", "nudge", "tap", "knock", "bump", "smack", "hit",
	"strike", "thump", "beat", "pound", "whack", "slam", "hammer", "thwack", "slap", "snap", "crack",
	"pop", "burst", "break", "crush", "squeeze", "compress", "squeeze", "jam", "shove", "thrust", "ram",
	"force", "drive", "propel", "catapult"])

var verb_count = verbs.size()


func random_action():
	var noun = random_noun()
	var verb = random_verb()
	
	if attacks.long_commands:
		noun += "o" + random_noun()

	var verb_complete = verb
	match verb_complete:
		"shut":
			pass
		"scan":
			verb_complete += "ned"
		"clamp":
			verb_complete += "ed"
		"run":
			pass
		"undo":
			verb_complete += "ne"
		"strike":
			verb_complete = "struck"
		_:
			if verb_complete.ends_with("el"):
				verb_complete += "led"
			elif verb_complete.ends_with("am"):
				verb_complete += "med"
			elif verb_complete.ends_with("p"):
				verb_complete += "ped"
			elif verb_complete.ends_with("e"):
				verb_complete += "d"
			else:
				verb_complete += "ed"


	if attacks.reverse_attack:
		noun = noun.reverse()
		verb = verb.reverse()
		verb_complete = verb_complete.reverse()
	
	
	var action: String
	action = verb + " the " + noun

	var action_complete: String
	action_complete = noun.capitalize() + " " + verb_complete
	
	if attacks.silly_case:
		action = sillify(action)
		action_complete = sillify(action_complete)

	return [action, action_complete]


func random_noun() -> String:
	return nonsense_noun[randi() % nonsense_noun_count]

func random_verb() -> String:
	return verbs[randi() % verb_count]
	

func sillify(original: String) -> String:
	var result = ""
	
	for i in range(original.length()):
		if i % 2 == 1:
			result += original[i].to_upper()
		else:
			result += original[i].to_lower()

	return result

