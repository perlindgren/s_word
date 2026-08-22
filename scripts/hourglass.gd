extends Sprite2D

@export var time : float = 60
@onready var seconds = $Seconds
var curr_time : float

func _ready() -> void:
	curr_time = time
	pass
	
func _process(delta) -> void:
	curr_time -= delta
	material.set_shader_parameter("ratio", 0.5 - curr_time/(2 * time))
	seconds.text = str("%.2f" % curr_time + "S LEFT") 
	if curr_time < 10.0:
		seconds.modulate = Color.DARK_RED
	else:
		seconds.modulate = Color.WHITE
	if curr_time < 0:
		curr_time = time;
