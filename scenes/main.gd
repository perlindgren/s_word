extends Node2D

@export var bricks_nr : int = 20
@export var brick_pos : Vector2 = Vector2(100.0, 100.0)
@export var brick_area_size : Vector2 = Vector2(1200.0, 700.0)

@export var slots_nr : int = 5
@export var slots_pos : Vector2 = Vector2(100.0, 950.0)
@export var slots_space : float = 125

@export var n_char : int = 25

const brick_resource : Resource = preload("res://scenes/brick.tscn")
const slot_resource : Resource = preload("res://scenes/slot.tscn")
var rng = RandomNumberGenerator.new()

func _ready() :
	print("main: _ready")
	
	var positions : Array[Vector2]= []
	for i in range(0, bricks_nr):
		# generate 
		var pos : Vector2;
		while true:
			pos = Vector2(randf(), randf()) * brick_area_size
			if positions.any(
				func (v: Vector2) -> bool: 
					return pos.distance_to(v) < 150
			):
				print("overlap ", pos)
			else:
				break
		
		# print("add pos ", pos, " to ", positions)
		positions.push_back(pos)
		
		var brick_instance = brick_resource.instantiate()
		brick_instance.position = pos + brick_pos
		brick_instance.modulate = Color(rng.randf_range(0.25, 1.0), rng.randf_range(0.25, 1.0), rng.randf_range(0.25, 1.0), 1.0)
		brick_instance.rotation = randf() * TAU
		brick_instance.old_rotation = brick_instance.rotation
		brick_instance.get_child(0).text = String.chr(65 + randi() % n_char)
		add_child(brick_instance)
		
	for i in range(1, slots_nr):
		var slot_instance = slot_resource.instantiate()
		slot_instance.position = Vector2(slots_space * i, 0.0) + slots_pos
		add_child(slot_instance)
