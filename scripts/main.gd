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

@onready var event_type = $EventType
@onready var event_name = $EventName
@onready var event_sprite = $EventSprite

func _ready() :
	print("main: _ready")
	Signals.dropped.connect(dropped)
	
	var event = GameState.events[GameState.event_nr]
	word = event.word
	var n_char = event.word.length()
	var bricks_nr = n_char + event.extra_chars
	print("event: ", event.name, " ", event.event, " ", word, " ", n_char)
	event_type.text = event.event
	event_name.text = event.name
	
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
		var char 
		if i < n_char:
			char =  word[i]
		else:
			char = String.chr(65 + randi() % 26)
		brick_instance.get_node("Label").text = char
		brick_instance.char = char
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

func dropped(p: int, char: String) -> void: 
	print("received drop ", p, " ", char)
	input[p] = char
	print("input ", input, "word", word)
	if input == word:
		print("success")
		GameState.cleared.push_back(GameState.event_nr)
		GameState.save()
		Signals.to_game_loop_menu.emit()
