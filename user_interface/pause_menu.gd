extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	testEsc()

func _ready():
	self.visible = false

func testEsc():
	if Input.is_action_just_pressed("esc") and (get_tree().paused == false):
		SoundManager.UI_ButtonPressed()
		print("esc was pressed")
		self.visible = true
		pause()
	elif Input.is_action_just_pressed("esc") and (get_tree().paused == true):
		SoundManager.UI_ButtonPressed()
		resume()

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	self.visible = false

func _on_continue_button_down() -> void:
	SoundManager.UI_ButtonPressed()
	print("continue")
	get_tree().paused = false
	self.visible = false

func _on_restart_button_down() -> void:
	SoundManager.UI_ButtonPressed()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/isometric_main.tscn")


func _on_continue_mouse_entered() -> void:
	SoundManager.UI_ButtonHovered()


func _on_restart_mouse_entered() -> void:
	SoundManager.UI_ButtonHovered()
