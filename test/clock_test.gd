extends Node2D

@onready var clock : Clock = $Clock

var sec: int = 0

func _ready() -> void:
	
	var tween = create_tween()
	tween.tween_method(
		func(s:float):
			clock.s = s
	, 0.0, 3600.0, 4
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	
	#clock.s = 0
	#for i in range(1, 10):
		#var tween = create_tween()
		#await tween.tween_property(clock,"s", 3600.0 * i, 10).set_trans(Tween.TRANS_EXPO).finished
	
