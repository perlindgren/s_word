extends Node2D

@onready var clock = $Clock
@onready var cleared = $Cleared
@onready var failed = $Failed
@onready var next_event = $NextEvent
@onready var current_event = $CurrentEvent
@onready var dice = $Dice
@onready var time : Label = $Time

func _ready() -> void:
	print("game_loop_menu")
	GameState.load()
	
	if GameState.master_sword_mode:
		time.text = "REAL TIME"
	else:
		time.text = "60x TIME"
	
	# Handle stickers for cleared events
	for c in cleared.get_children():
		#print("c ", c)
		c.visible = false
		
	for i in GameState.cleared:
		#print("i ", i)
		var c = cleared.get_child(i)
		c.visible = true
	
	# Handle stickers for failed events
	for c in failed.get_children():
		#print("c ", c)
		c.visible = false
		
	for i in GameState.failed:
		#print("i ", i)
		var c = failed.get_child(i)
		c.visible = true
	
	print("Text ", GameState.events[0].text, ", word", GameState.events[0].word)
	
func _on_start_button_pressed() -> void:
	print("_on_start_button_pressed, emit to_game_loop")
	to_game_loop()

func to_game_loop() -> void:
	print("to_game_loop")
	
	# Check that we are not in a transition already
	if !dice.playing:
		dice.play()
		await dice.finished
		Signals.to_game_loop.emit()

func _on_exit_button_pressed() -> void:
	print("_on_exit_button_pressed, emit to_start_menu")
	Signals.to_start_menu.emit()
	
func _on_reset_button_pressed() -> void:
	print("_on_reset_button_pressed, emit to_game_loop_menu")
	GameState.cleared = []
	GameState.failed = []
	GameState.save()
	Signals.to_game_loop_menu.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("_unhandled_input ui_cancel, emit to_start_menue")
		Signals.to_start_menu.emit()

func _process(_delta) -> void:
	var s = clock.s_state
	
	var seconds: int = int(fmod(s, 60))
	var minutes: int = int(fmod(s / 60, 60))
	var hours: int = int(fmod(s / (60 * 60), 12))
	GameState.event_nr = (12 + hours - 1) % 12
	
	# print("s ", seconds, " m ", minutes, " h ", hours)
	
	if minutes == 0 && seconds == 0:
		print("new challenge ", hours)
		to_game_loop()
	
	next_event.text = "MINUTES UNTIL\nNEXT EVENT " + str(60 - minutes)
	current_event.text = "EVENT # " + str(GameState.event_nr + 1)
