class_name StartMenu extends Node2D

@onready var exit_button = $ExitButton
@onready var start_button = $StartButton
@onready var master = $Master
@onready var quick = $Quick
@onready var start1 = $Start1
@onready var start2 = $Start2
@onready var clock : Clock = $Clock
@onready var time : Label = $Time

var tween: Tween = null

func _ready() -> void:
	set_time()
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
	GameState.s_offset = 0
	set_time()
	clock.set_state()

func _on_quick_button_pressed() -> void:
	print("quick")
	GameState.master_sword_mode = false
	GameState.clock_init()
	set_time()
	clock.set_state()
	
func set_time() -> void:
	if GameState.master_sword_mode:
		time.text = "REAL TIME"
	else:
		time.text = "60x SPEEDUP"
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("_unhandled_input ui_cancel, emit to_game_loop_menue")
		Signals.to_intro_menu.emit()
