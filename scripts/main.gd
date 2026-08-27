class_name Main extends Node2D

@export var brick_area_pos : Vector2 = Vector2(100.0, 100.0)
@export var brick_area_size : Vector2 = Vector2(1200.0, 700.0)
@export var brick_color_min : float = 0.25
@export var brick_color_max : float = 1.00
@export var brick_speed : float = 50
@export var brick_rotation_speed : float = 0.05
@export var brick_max_rotation_speed : float = 1.0

@export var slots_pos : Vector2 = Vector2(100.0, 950.0)
@export var slots_space : float = 125

const brick_resource : Resource = preload("res://scenes/brick.tscn")
const slot_resource : Resource = preload("res://scenes/slot.tscn")
var rng = RandomNumberGenerator.new()
var input : String
var word : String

@onready var hourglass = $Hourglass
@onready var event_text = $EventText
@onready var event_sprite = $EventSprite
@onready var audio = $Audio
@onready var cleared = $Cleared
@onready var your_did_it = $YourDidIt
@onready var end = $End
@onready var klonk = $Klonk
@onready var swoof = $Swoof

func _ready() :
	print("main: _ready")
	Signals.dropped.connect(dropped)
	Signals.time_expired.connect(time_expired)
	
	your_did_it.visible = false
	
	#Audio
	var clips = audio.get_children()
	clips[GameState.event_nr].playing = true
	
	var event = GameState.events[GameState.event_nr]
	word = event.word
	var n_char = event.word.length()
	var bricks_nr = n_char + event.extra_chars
	print("event: ", event.text, ", word ", word, "n_char ", n_char, "bricks_nr", bricks_nr)
	event_text.text = event.text
	
	input = "                    ".left(n_char)
	print("input", input, input.length())
	
	# Make all EventSprites invisible
	var event_sprites = event_sprite.get_children()
	for e in event_sprites:
		e.visible = false
	event_sprites[GameState.event_nr].visible = true
	
	var positions : Array[Vector2]= []
	var nr_overlaps : int = 0
	for i in range(0, bricks_nr):
		# generate 
		var pos : Vector2;
		while true:
			pos = Vector2(randf(), randf()) * brick_area_size
			if positions.any(
				func (v: Vector2) -> bool: 
					return pos.distance_to(v) < 150
			):
				# print("overlap ", pos)
				nr_overlaps += 1
			else:
				break
		
		print("i, nr_overlaps ", nr_overlaps)
		# print("add pos ", pos, " to ", positions)
		positions.push_back(pos)
		
		var brick_instance = brick_resource.instantiate()
		brick_instance.position = pos + brick_area_pos
		brick_instance.modulate = Color(rng.randf_range(brick_color_min, brick_color_max), rng.randf_range(brick_color_min, brick_color_max), rng.randf_range(brick_color_min, brick_color_max), 1.0)
		brick_instance.rotation = randf() * TAU
		brick_instance.old_rotation = brick_instance.rotation
		var char_str : String 
		if i < n_char:
			char_str =  word[i]
		else:
			char_str = String.chr(65 + randi() % 26)
		brick_instance.get_node("Label").text = char_str
		brick_instance.char_str = char_str	
		brick_instance.get_node("Label").visible = false # start folded
		brick_instance.move_speed = Vector2(rng.randf_range(-brick_speed, brick_speed), rng.randf_range(-brick_speed, brick_speed))
		brick_instance.rotation_speed = rng.randf_range(-brick_rotation_speed, brick_rotation_speed) 
		brick_instance.z_index = i
		add_child(brick_instance)
		
	for i in range(0, n_char):
		var slot_instance = slot_resource.instantiate()
		slot_instance.position = Vector2(slots_space * i, 0.0) + slots_pos
		slot_instance.index = i
		add_child(slot_instance)

	# Formatting examples
	# print(str("%*.*f" % [5, 2, 0]))
	# print(str("%*.*f" % [5, 2, 60.23]))
	# print(str("%*.*f" % [5, 2, 3.2]))

func dropped(p: int, char_str: String) -> void: 
	print("received drop ", p, " ", char_str)
	input[p] = char_str
	print("input ", input, "word", word)
	if input == word:
		print("success")
		klonk.play()
		await tween_sprite(event_sprite)
		
		if !GameState.cleared.has(GameState.event_nr):
			GameState.cleared.push_back(GameState.event_nr)
			
		if GameState.cleared.size() == 12:
			hourglass.curr_time = -1 # will prevent time_expired
			end.play()
			await end.finished
			GameState.cleared = []
			GameState.failed = []
		GameState.save()
		Signals.to_game_loop_menu.emit()
		
# Called by Hourglass when time runs out
func time_expired() -> void:
	print("time is up")
	swoof.play()
	your_did_it.visible = true
	await tween_sprite(your_did_it)
	
	if !GameState.failed.has(GameState.event_nr):
		GameState.failed.push_back(GameState.event_nr)
	GameState.save()
	
	Signals.to_game_loop_menu.emit()
	
func tween_sprite(sprite) -> void:
	var to_pos = cleared.get_children()[GameState.event_nr].position
	var tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(40,40), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation", TAU, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(sprite, "scale", Vector2.ZERO,1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation", -TAU, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position", to_pos, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("_unhandled_input ui_cancel, emit to_game_loop_menue")
		Signals.to_game_loop_menu.emit()
