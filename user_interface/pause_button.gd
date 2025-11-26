extends CanvasLayer

signal paused_pressed

func _on_texture_button_pressed() -> void:
	paused_pressed.emit()
	print("pause button pressed.")
