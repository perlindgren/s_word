extends Node2D

@export var bricks_nr : int = 10
@export var brick_pos : Vector2 = Vector2(100.0, 100.0)
@export var brick_size : Vector2 = Vector2(800.0, 600.0)

@export var slots_nr : int = 5
@export var slots_pos : Vector2 = Vector2(100.0, 900.0)
@export var slots_space : float = 100

const brick_resource : Resource = preload("res://scenes/brick.tscn")
const slot_resource : Resource = preload("res://scenes/slot.tscn")

func _ready() :
	print("main: _ready")
	for i in range(1, bricks_nr):
		var brick_instance = brick_resource.instantiate()
		brick_instance.position = Vector2(randf(), randf()) * brick_size + brick_pos
		brick_instance.modulate = Color(randfn(0.2, 1.0), randfn(0.2, 1.0), randfn(0.2, 1.0))
		brick_instance.rotation = randf() * TAU
		brick_instance.old_rotation = brick_instance.rotation
		add_child(brick_instance)
		
	for i in range(1, slots_nr):
		var slot_instance = slot_resource.instantiate()
		slot_instance.position = Vector2(slots_space * i, 0.0) + slots_pos
		add_child(slot_instance)
