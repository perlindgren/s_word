extends Sprite2D

@export var time : float = 20
@onready var seconds = $Seconds
var curr_time : float

func _ready() -> void:
	curr_time = time
	pass
	
func _process(delta) -> void:
	curr_time -= delta
	if curr_time < 0:
		curr_time = time;
		print("you loose")
		
	material.set_shader_parameter("ratio", 0.5 - curr_time/(2 * time))
	seconds.text = str("%*.*f" % [5, 2,curr_time]) 
	if curr_time < 15.0 and 20 / curr_time - int(20/curr_time)> 0.5 :
		modulate = Color.RED# Color(1 - curr_time * 0.1, 0, 0, 1)
	else:
		modulate = Color.WHITE
	if curr_time < 0:
		curr_time = time;
