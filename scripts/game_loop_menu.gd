extends Node2D


func _on_start_button_pressed() -> void:
	print("_on_start_button_pressed, emit to_game_loop")
	Signals.to_game_loop.emit()


func _on_exit_button_pressed() -> void:
	print("_on_exit_button_pressed, emit to_start_menu")
	Signals.to_start_menu.emit()
	
	
