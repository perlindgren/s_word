extends Node2D

@onready var intro_menu = preload("res://scenes/intro_menu.tscn")
@onready var start_menu = preload("res://scenes/start_menu.tscn")
@onready var game_loop_menu = preload("res://scenes/game_loop_menu.tscn")
@onready var game_loop = preload("res://scenes/game_loop.tscn")

var current_child_scene : Node = null

func _ready() -> void:
	# Connect signals
	Signals.to_intro_menu.connect(to_intro_menu)
	Signals.to_start_menu.connect(to_start_menu)
	Signals.to_game_loop_menu.connect(to_game_loop_menu)
	Signals.to_game_loop.connect(to_game_loop)
	change_scene(intro_menu)
	#change_scene(game_loop_menu)
	#change_scene(start_menu)

func change_scene(to) -> void:
	if current_child_scene:
		current_child_scene.queue_free()
		
	current_child_scene = to.instantiate()
	add_child(current_child_scene)

func to_intro_menu() -> void: 
	print("to_start_menu")
	change_scene(intro_menu)
	
func to_start_menu() -> void: 
	print("to_start_menu")
	change_scene(start_menu)

func to_game_loop_menu() -> void: 
	print("to_game_loop_menu")
	change_scene(game_loop_menu)
	
func to_game_loop() -> void: 
	print("to_game_menu")
	change_scene(game_loop)
