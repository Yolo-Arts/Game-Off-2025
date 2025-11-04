extends Node

var camera

var player_health: float = 100

var flag = true

signal player_died

func _process(delta):
	if player_health < 0 && flag == true:
		print("player died")
		player_died.emit()
		flag = false
