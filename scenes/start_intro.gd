extends Node2D

@onready var n65 = $N65
@onready var the_pen = $ThePen
@onready var s_word = $SWORD
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var text_to_show: String = "THE PEN IS MIGHTIER THAN THE"
@export var n65_duration: float = 5.0
@export var display_speed: float = 0.1 # Time in seconds per character
@export var s_word_tween_time: float = 3
@export var s_word_y : float = 524.0

var last_visible_chars = 0
var last_value: float = 0.0
var last_direction: bool = true # down

func _ready() -> void:
	the_pen.modulate = Color.TRANSPARENT
	s_word.modulate = Color.TRANSPARENT
	the_pen.visible_characters = 0
	last_visible_chars = 0
	var total_chars = the_pen.get_total_character_count()
	var duration = total_chars * display_speed
	
	var tween = create_tween()
	await tween.tween_property(n65, "modulate:a", 0.0, n65_duration).set_ease(Tween.EASE_IN_OUT).finished
	
	the_pen.modulate = Color.WHITE
	
	tween = create_tween()
	await tween.tween_property(the_pen, "visible_characters", total_chars, duration).finished
	
	s_word.position.y = -165
	s_word.modulate = Color.WHITE
	
	# Bounce the sWORD to land on positoin.y 524.
	tween = create_tween()
	#await tween.tween_property(s_word, "position:y", 524, s_word_tween_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).finished
	await tween.tween_method(on_bounce_step, -165, 524.0, s_word_tween_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).finished
	
func _process(_delta: float) -> void:
	# Detect exactly when a new character is revealed on screen
	if the_pen.visible_characters > last_visible_chars:
		audio_player.play()
		
	# Keep track of the current character state
	last_visible_chars = the_pen.visible_characters

func on_bounce_step(current_value: float) -> void:
	s_word.position.y = current_value
	var direction = false if current_value > last_value else true
		
	if direction and direction != last_direction: 
		audio_player.play()
	
	last_value = current_value
	last_direction = direction
