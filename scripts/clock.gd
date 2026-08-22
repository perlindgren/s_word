extends Node2D

@export_range(0, 60, 1) var s : float = 0.0
@export_range(0, 60, 1) var m : float = 0.0
@export_range(0, 24, 1) var h : float = 0.0

@onready var seconds = $Seconds
@onready var minutes = $Minutes
@onready var hours = $Hours

func _ready() -> void:
	print("clock _ready")

func _process(_delta) -> void:
	seconds.rotation = TAU * (s/60.0 + 0.01) 
	minutes.rotation = TAU * (m/60.0 + s/3600)
	hours.rotation = TAU * (h/12.0 + m/(12 * 60.0))
	
func set_seconds(sec: int) -> void:
	s = sec % 60
	m = int(sec / 60.0) % 60
	h = int(sec / 3600.0) % 12
