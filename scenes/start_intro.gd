extends Node2D

@onready var n65 = $N65
@onready var the_pen = $ThePen
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var text_to_show: String = "THE PEN IS MIGHTIER THAN THE"
@export var n65_duration: float = 1.0
@export var display_speed: float = 0.1 # Time in seconds per character

var last_visible_chars = 0

func _ready() -> void:
	the_pen.modulate = Color.TRANSPARENT
	the_pen.visible_characters = 0
	last_visible_chars = 0
	var total_chars = the_pen.get_total_character_count()
	var duration = total_chars * display_speed
	
	var tween = create_tween()
	await tween.tween_property(n65, "modulate:a", 0.0, n65_duration).set_ease(Tween.EASE_IN_OUT).finished
	
	the_pen.modulate = Color.WHITE
	
	tween = create_tween()
	tween.tween_property(the_pen, "visible_characters", total_chars, duration)
	
func _process(_delta: float) -> void:
	# Detect exactly when a new character is revealed on screen
	if the_pen.visible_characters > last_visible_chars:
		audio_player.play()
		
	# Keep track of the current character state
	last_visible_chars = the_pen.visible_characters
