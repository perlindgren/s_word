extends Node2D

@onready var clock = $Clock
@onready var cleared = $Cleared
@onready var next_event = $NextEvent
@onready var current_event = $CurrentEvent

func _ready() -> void:
	for c in cleared.get_children():
		print("c ", c)
		c.visible = false
		
	for i in GameState.cleared:
		print("i ", i)
		var c = cleared.get_child(i)
		c.visible = true
	
	print("here ", GameState.events[0].name, GameState.events[0].event, GameState.events[0].word )
	
func _on_start_button_pressed() -> void:
	print("_on_start_button_pressed, emit to_game_loop")
	Signals.to_game_loop.emit()


func _on_exit_button_pressed() -> void:
	print("_on_exit_button_pressed, emit to_start_menu")
	Signals.to_start_menu.emit()
	
	
func _process(_delta) -> void:
	var local_time_dict = Time.get_datetime_dict_from_system()
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	if !GameState.master_sword_mode:
		s *= 60	
	clock.s = s
	
	var seconds: int = fmod(s, 60)
	var minutes: int = fmod(s/60, 60)
	var hours: int = fmod(s/(60 * 60), 12)
	GameState.event_nr = hours
	
	if minutes == 0 && seconds == 0:
		print("new challenge ", hours)
		Signals.to_game_loop.emit()
	
	next_event.text = "MINUTES UNTILL NEXT EVENT " + str(60 - minutes) 
	current_event.text = "EVENT # " + str(GameState.event_nr + 1) 
