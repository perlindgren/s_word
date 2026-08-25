extends Node2D

@onready var n65 = $N65
@onready var the_pen = $ThePen
@onready var s_word = $SWORD
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var word = $SWORD/WORD
@onready var time = $TIME
@onready var start_button = $StartButton
@onready var decode_button = $DecodeButton
@onready var transmit_button = $TransmitButton
@onready var what_is_art = [$WhatIsArt, $AreGamesArt, $WeAtN65]

# @export var text_to_show: String = "THE PEN IS MIGHTIER THAN THE"
@export var n65_duration: float = 5.0
@export var display_speed: float = 0.1 # Time in seconds per character
@export var s_word_tween_time: float = 3
@export var s_word_y : float = 524.0

var last_visible_chars = 0
var last_value: float = 0.0
var last_direction: bool = true # down
var nr_bounce : int = 0
var time_last_visible_chars = 0
var decode : int = 0

# What is art? Are games art? We at N65 think so!
func _ready() -> void:
	the_pen.visible = false
	s_word.visible = false
	time.visible = false
	start_button.visible = false
	decode_button.visible = false
	
	for i in range(0,3):
		what_is_art[i].visible = false
		
	# wait here until transmissions are finished
	#while decode < 4:
		#pass
		
	the_pen.visible_characters = 0
	time.visible_characters = 0
	last_visible_chars = 0
	var total_chars = the_pen.get_total_character_count()
	var duration = total_chars * display_speed
	
	var tween = create_tween()
	await tween.tween_property(n65, "modulate:a", 0.1, n65_duration).set_ease(Tween.EASE_IN_OUT).finished
	
	the_pen.visible = true
	
	tween = create_tween()
	await tween.tween_property(the_pen, "visible_characters", total_chars, duration).finished
	
	s_word.position.y = -165
	s_word.visible = true
	
	# Bounce the sWORD to land on positoin.y 524.
	tween = create_tween()
	await tween.tween_method(on_bounce_step, -165, 524.0, s_word_tween_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).finished
	
	time.visible = true
	total_chars = time.get_total_character_count()
	duration = total_chars * display_speed
	time_last_visible_chars = 0
	tween = create_tween()
	await tween.tween_property(time, "visible_characters", total_chars, duration).finished
	
	start_button.visible = true
	
var my_time: float = 0
func _process(delta: float) -> void:
	# Detect exactly when a new character is revealed on screen
	if the_pen.visible_characters > last_visible_chars or time.visible_characters > time_last_visible_chars:
		audio_player.play()
		print("audio play ", time.visible_characters)
		
	# Keep track of the current character state
	last_visible_chars = the_pen.visible_characters 
	time_last_visible_chars = time.visible_characters
	
	my_time += delta
	var curr_time = my_time
	
	for i in range(0, 3):
		var art = what_is_art[i]
		art.position.x = 300.0 + 100.0 * (i + 1.0) * sin(fmod(i + curr_time * 1.0, TAU))
		art.position.y = 500.0 + 100.0 * (i + 1.0) * cos(fmod(i + curr_time * 1.0, TAU))
		

func on_bounce_step(current_value: float) -> void:
	s_word.position.y = current_value
	var direction = false if current_value > last_value else true
		
	if direction and direction != last_direction: 
		audio_player.play()
		print("bounce")
		word.visible_characters = nr_bounce
		nr_bounce += 1
	last_value = current_value
	last_direction = direction


func _on_start_button_pressed() -> void:
	print("_on_start_button_pressed")
	Signals.to_start_menu.emit()


func _on_decode_button_pressed() -> void:
	print("_on_decode_button_pressed")
	if decode < 4:
		what_is_art[decode - 1].visible = true
		decode_button.visible = false

func _on_transmit_button_pressed() -> void:
	print("_on_transmit_button_pressed")
	if decode < 3:
		decode_button.visible = true
		what_is_art[decode].get_child(0).play()
		decode += 1
		if decode == 3:
			transmit_button.visible = false
			
