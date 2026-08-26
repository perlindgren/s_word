class_name StartMenu extends Node2D

@onready var exit_button = $ExitButton
@onready var start_button = $StartButton
@onready var master = $Master
@onready var quick = $Quick
@onready var start1 = $Start1
@onready var start2 = $Start2
@onready var clock : Clock = $Clock

var tween: Tween = null

func _ready() -> void:
	set_state()
	
	start1.play()
	await start1.finished
	await get_tree().create_timer(5.0).timeout
	start2.play()
	await start2.finished
	await get_tree().create_timer(30.0).timeout
	Signals.to_intro_menu.emit()

# Signals bound in editor
func _on_exit_button_pressed() -> void:
	Signals.to_intro_menu.emit()
	#print("exit")
	#get_tree().quit()

func _on_start_button_pressed() -> void:
	Signals.to_game_loop_menu.emit()

func _on_master_button_pressed() -> void:
	print("master")
	GameState.master_sword_mode = true
	set_state()

func _on_quick_button_pressed() -> void:
	print("quick")
	GameState.master_sword_mode = false
	set_state()

func set_state() -> void:
	if GameState.master_sword_mode:
		master.modulate = Color.WHITE
		quick.modulate = Color(1,1,1, 0.25)
	else:
		quick.modulate = Color.WHITE
		master.modulate = Color(1,1,1, 0.25)
		
	var to_s = compute_s() + 4 * (1 if GameState.master_sword_mode else 60)
	tween = create_tween()
	await tween.tween_method(
		func(s:float):
			clock.s = s
	, clock.s, to_s, 4
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).finished	
	tween = null
		
func compute_s() -> float:
	var local_time_dict = Time.get_datetime_dict_from_system()
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	s = s if GameState.master_sword_mode else 60 * s
	return fmod(s, 12 * 3600)

func _process(_delta) -> void:
	if !tween:
		clock.s = compute_s()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("_unhandled_input ui_cancel, emit to_game_loop_menue")
		Signals.to_intro_menu.emit()
