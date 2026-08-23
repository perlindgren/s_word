class_name Clock extends Node2D

@export_range(0, 60 * 60 * 2, 1) var s : float = 0.0

@onready var seconds = $Seconds
@onready var minutes = $Minutes
@onready var hours = $Hours

func _ready() -> void:
	print("clock _ready")

func _process(_delta) -> void:
	seconds.rotation = fmod(TAU * s/60, TAU)
	minutes.rotation = fmod(TAU * s/3600, TAU)
	hours.rotation = fmod(TAU * s/(12 * 3600), TAU)
