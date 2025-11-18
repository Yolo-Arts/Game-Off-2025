extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	testEsc()

func _ready():
	self.visible = false

func testEsc():
	if Input.is_action_just_pressed("esc") and (get_tree().paused == false):
		print("esc was pressed")
		self.visible = true
		pause()
	elif Input.is_action_just_pressed("esc") and (get_tree().paused == true):
		resume()

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	self.visible = false

func _on_continue_button_down() -> void:
	print("continue")
	get_tree().paused = false
	self.visible = false

func _on_restart_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/isometric_main.tscn")
