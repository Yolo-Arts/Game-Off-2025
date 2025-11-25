extends CanvasLayer
@onready var pause_button: CanvasLayer = $"../PauseButton"

func _ready() -> void:
	self.visible = false
	Globals.player_died.connect(dead_player)

func dead_player():
	pause_button.visible = false
	Globals.camera.shake(1, 30, 30)
	self.visible = true
