class_name Circle extends Node2D

@export var active : bool = false
@export var red_radius : float = 20
@export var circle_radius: float = 100.0
@export var stroke_width: float = 8.0
@export var circle_color: Color = Color.CYAN

var tween : Tween

func _draw() -> void:
	if active:
		draw_circle(Vector2.ZERO, red_radius, Color(1, 0, 0, 0.4))
		draw_arc(Vector2.ZERO, circle_radius, 0.0, TAU, 120, circle_color, stroke_width, true)

func _process(_delta: float) -> void:
	queue_redraw()
	
func transmit() -> void:
	active = true
	while true:
		tween = create_tween()
		circle_radius = 20
		await tween.tween_property(self, "circle_radius", 500, 1).finished

func stop() -> void:
	active = false
	tween.kill()
