extends Label


func _process(delta: float) -> void:
	text = "hp: " + str(Globals.player_health)
