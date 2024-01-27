extends Node

@onready var track1 = $"1"
@onready var track2 = $"2"
@onready var track3 = $"3"
@onready var track4 = $"4"

func _on_1_finished():
	track2.play()


func _on_2_finished():
	track3.play()


func _on_3_finished():
	track4.play()


func _on_4_finished():
	track4.play()
