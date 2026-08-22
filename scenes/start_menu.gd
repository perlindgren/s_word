extends Node2D

@onready var exit_button = $ExitButton

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
