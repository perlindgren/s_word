extends Node2D

@onready var clock = $Clock

var sec: int = 0

func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	sec += 11
	clock.set_seconds(sec)	
