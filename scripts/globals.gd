extends Node

var camera

signal exp_collected
var player_health: float = 5

var playerDied = false

signal player_died

func _process(delta):
	if player_health < 0 && playerDied == false:
		print("player died")
		player_died.emit()
		playerDied = true
