extends TextureButton


func _on_mouse_entered() -> void:
	modulate = Color.GRAY
	print("hover exit")

func _on_mouse_exited() -> void:
	modulate = Color.WHITE
	print("hover exit")
	
