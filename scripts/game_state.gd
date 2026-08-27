extends Node

@export var master_sword_mode = false

# The cleared challenges
@export var cleared : Array = []
@export var failed : Array = []
@export var event_nr : int = 0
@export var s_offset : float = 0

const file_name = "user://savegame.save"

class Data:
	var text : String
	var word : String
	var extra_chars : int
	var flipped : float
	
	func _init(t: String, w: String, ex: int, f: float):
		text = t
		word = w
		extra_chars = ex
		flipped = f

var events : Array[Data] = [
	Data.new(
		"Goblin\nDislikes", 
		"SWORD", 0, 0),
	Data.new(
		"Dwarfs\nwant", 
		"GOLD", 1, 0.2),
	Data.new(
		"Feed\nRobot", 
		"OIL", 2, 0.3),
	Data.new(
		"Help\nHouse On Fire", 
		"WATER", 3, 0.4),
	Data.new(
		"Feed\nDog", 
		"BONE", 4, 0.5),
	Data.new(
		"Pillow Man\nWants", 
		"BLANKET", 5, 0.6),
	Data.new(
		"Feed\nSeagull with\nBubble Gun", 
		"FRIES", 6, 0.7),
	Data.new(
		"Feed\nCat", 
		"CATNIP", 6, 0.8),
	Data.new(
		"Pizza Man\nNeeds", 
		"TOMATO", 7, 0.9),
	Data.new(
		"Fish\nWants", 
		"AQUARIUM", 7, 1.0),
	Data.new(
		"Cake\nStarts the", 
		"BIRTHDAY", 8, 1.0),
	Data.new(
		"John Smith\nReally Wants\nA NEW", 
		"SMARTPHONE", 8, 1.0)
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

# Time related global functions
func compute_s() -> float:
	var local_time_dict = Time.get_datetime_dict_from_system()
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	s = s if master_sword_mode else 60 * s
	return fmod(s_offset + s, 12 * 3600)
	
func clock_init() -> void:
	master_sword_mode = false
	s_offset = 0
	s_offset = 3600 - compute_s() # one hour in 
