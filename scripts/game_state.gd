extends Node

@export var master_sword_mode = false

# The cleared challenges
@export var cleared : Array = []
@export var failed : Array = []
@export var event_nr : int = 0

const file_name = "user://savegame.save"

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
	Data.new("Goblin", "Likes", "SWORD", 0, 0),
	Data.new("Dwarf", "Wants", "GOLD", 1, 0.2),
	Data.new("Robot", "Feed", "OIL", 2, 0.3),
	Data.new("House On Fire", "Help", "WATER", 3, 0.4),
	Data.new("Dog", "Feed", "BONE", 4, 0.5),
	Data.new("Pillow Man", "Wants", "BLANKET", 5, 0.6),
	Data.new("Seagull with\nBubble Gun", "Feed", "FRIES", 6, 0.7),
	Data.new("Cat", "Feed", "CATNIP", 6, 0.8),
	Data.new("Pizza Man", "Wants", "TOMATO", 7, 0.9),
	Data.new("Fish", "Wants", "AQUARIUM", 7, 1.0),
	Data.new("Cake", "Needs", "BIRTHDAY", 8, 1.0),
	Data.new("John Smith", "Wants", "SMARTPHONE", 8, 1.0)
]

func save() -> void:
	print("save")
	var json_native = JSON.from_native(cleared, true)
	var json_string = JSON.stringify(json_native)
	var json_native2 = JSON.from_native(failed, true)
	var json_string2 = JSON.stringify(json_native2)
	print("str ", json_string, json_string2)
	var save_file = FileAccess.open(file_name, FileAccess.WRITE)
	save_file.store_line(json_string)
	save_file.store_line(json_string2)
	save_file.close()
	

func load() -> void:
	print("load")
	var save_file = FileAccess.open(file_name, FileAccess.READ)
	if !save_file:
		print("no save file found")
		return
	var json_string = save_file.get_line()
	print("json_string", json_string)
	var json_native = JSON.parse_string(json_string)
	cleared = JSON.to_native(json_native, true)
	print(cleared)
	json_string = save_file.get_line()
	json_native = JSON.parse_string(json_string)
	failed = JSON.to_native(json_native, true)
	print(failed)

# Project -> Open User Data, to view the stored files

	
