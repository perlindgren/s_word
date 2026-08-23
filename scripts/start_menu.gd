class_name StartMenu extends Node2D

@onready var exit_button = $ExitButton
@onready var clock : Clock = $Clock

func _on_texture_button_pressed() -> void:
	print("exit")
	get_tree().quit()

func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate = Color.GRAY
	print("hover exit")


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate = Color.WHITE
	print("hover exit")


func _on_exit_button_pressed() -> void:
	print("exit")
	get_tree().quit()

func _process(_delta) -> void:
	#var s = Time.get_unix_time_from_system()
	#print("unix s", s)
	#clock.s = s
	
	# Get local time as a formatted string (HH:MM:SS)
	# var local_time_str = Time.get_time_string_from_system()
	# print("Local time string: ", local_time_str)
	var local_time_dict = Time.get_datetime_dict_from_system()
  
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	clock.s = s
