class_name Clock extends Node2D

@onready var seconds = $Seconds
@onready var minutes = $Minutes
@onready var hours = $Hours

var s_offset : float = 0
var s_state : float = 0
var tween : Tween = null

func _ready() -> void:
	print("clock _ready")

func _process(_delta) -> void:
	if !tween:
		s_state = compute_s() 
	seconds.rotation = fmod(TAU * s_state/60 + 0.06, TAU)
	minutes.rotation = fmod(TAU * s_state/3600, TAU)
	hours.rotation = fmod(TAU * s_state/(12 * 3600), TAU)

func compute_s() -> float:
	var local_time_dict = Time.get_datetime_dict_from_system()
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	s = s if GameState.master_sword_mode else 60 * s
	return fmod(s_offset + s, 12 * 3600)

func set_state() -> void:
	var to_s
	if GameState.master_sword_mode:
		s_offset = 0
		to_s = compute_s() 
	else:
		s_offset = 3600 - compute_s()
		to_s = compute_s() + 4 * 60 
		
	tween = create_tween()
	await tween.tween_method(
		func(sec:float):
			s_state = sec
	, s_state, to_s, 4
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).finished	
	tween = null
