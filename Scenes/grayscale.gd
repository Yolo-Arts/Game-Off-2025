extends CanvasLayer

func _ready() -> void:
	self.visible = false
	Globals.player_died.connect(dead_player)

func dead_player():
	Globals.camera.shake(1, 30, 30)
	self.visible = true
