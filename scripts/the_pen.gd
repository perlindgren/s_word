extends RichTextLabel

## The time delay between standard alphabetical characters
@export var default_text_speed: float = 0.03

## Time delay extension when encountering punctuation marks like . , ? !
@export var punctuation_pause: float = 0.25

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_tween: Tween
var last_visible_chars: int = 0

func _ready() -> void:
	# Example usage text
	display_text("THE PEN IS MIGHTIER THAN THE SWORD")


func _process(_delta: float) -> void:
	# Detect exactly when a new character is revealed on screen
	if visible_characters > last_visible_chars:
		play_character_sound()
		
	# Keep track of the current character state
	last_visible_chars = visible_characters


## Prepares the label and executes the typewriter sequence
func display_text(new_text: String) -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()
	
	text = new_text
	visible_characters = 0
	last_visible_chars = 0 # Reset audio tracker
	
	var total_chars = get_total_character_count()
	current_tween = create_tween()
	
	for i in range(1, total_chars + 1):
		current_tween.tween_property(self, "visible_characters", i, default_text_speed)
		
		var current_char = text[clamp(i - 1, 0, text.length() - 1)]
		if current_char in [".", ",", "!", "?", ":"]:
			current_tween.tween_interval(punctuation_pause)


## Evaluates the current character and triggers the sound node
func play_character_sound() -> void:
	# Safety check to prevent crashing if the array index overflows
	if visible_characters > text.length():
		return
		
	# Get the specific character that was just revealed
	var current_char = text[visible_characters - 1]
		
	# Subtle pitch randomization makes the voice sound organic and less repetitive
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()


## Instantly displays the full line of text when the player clicks skip
func skip_to_end() -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()
	visible_characters = -1
	last_visible_chars = get_total_character_count() # Prevents massive audio burst on skip
