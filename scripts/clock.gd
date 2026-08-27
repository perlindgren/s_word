class_name Clock extends Node2D

@onready var seconds = $Seconds
@onready var minutes = $Minutes
@onready var hours = $Hours

var s_state : float = 0
var tween : Tween = null

func _ready() -> void:
	print("clock _ready")
	s_state = GameState.compute_s() 

func _process(_delta) -> void:
	if !tween:
		s_state = GameState.compute_s() 
	seconds.rotation = fmod(TAU * s_state/60 + 0.06, TAU)
	minutes.rotation = fmod(TAU * s_state/3600, TAU)
	hours.rotation = fmod(TAU * s_state/(12 * 3600), TAU)

func set_state() -> void:
	var to_s = GameState.compute_s() + 4 if GameState.master_sword_mode else 4 * 60

	tween = create_tween()
	await tween.tween_method(
		func(sec:float):
			s_state = sec
	, s_state, to_s, 4
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).finished	
	tween = null
