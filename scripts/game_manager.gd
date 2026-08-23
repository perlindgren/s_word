extends Node2D

@onready var start_menu = preload("res://scenes/start_menu.tscn")
@onready var game_loop_menu = preload("res://scenes/game_loop_menu.tscn")

var current_scene

func _ready() -> void:
	# Connect signals
	Signals.main_menu_start.connect(_on_main_menu_start)
	
	var scene = start_menu.instantiate()
	current_scene = scene
	add_child(scene)

func _on_main_menu_start() -> void: 
	print("start here")
	get_tree().change_scene_to_packed(game_loop_menu)
