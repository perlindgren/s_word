extends Node

@export var master_sword_mode = false

# The cleared challenges
@export var cleared : Array = [0, 2, 5, 8, 11]
@export var event_nr : int = 2

class Data:
	var name : String
	var event : String
	var word : String
	var extra_chars : int
	var flipped : float
	
	func _init(n: String, e: String, w: String, ex: int, f: float):
		name = n
		event = e
		word = w
		extra_chars = ex
		flipped = f

var events : Array[Data] = [
	Data.new("Goblin", "Kill", "SWORD", 0, 0),
	Data.new("Dwarf", "Wants", "GOLD", 1, 0.2),
	Data.new("Robot", "Feed", "OIL", 2, 0.3),
	Data.new("House", "Help", "WATER", 3, 0.4),
	Data.new("Dog", "Feed", "BONE", 4, 0.5),
	Data.new("Pillow Man", "Wants", "BLANKET", 5, 0.6),
	Data.new("Seagull with Gun", "Feed", "FRIES", 6, 0.7),
	Data.new("Cat", "Feed", "CATNIP", 6, 0.8),
	Data.new("Pizza Man", "Wants", "Tomatoe", 7, 0.9),
	Data.new("Fish", "Wants", "AQUARIUM", 7, 1.0),
	Data.new("Cake", "Needs", "BIRTHDAY", 8, 1.0),
	Data.new("John Smith", "Wants", "SMARTPHONE", 8, 1.0)
]

func save() -> void:
	print("save")
	pass

func load() -> void:
	print("load")
	pass
