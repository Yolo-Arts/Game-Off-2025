extends Node2D

@onready var camera = %Camera2D

@onready var game_over = $UI/GameOver

func _ready():
	Globals.playerDied = false
	Globals.camera = camera
	game_over.visible = false
	Globals.player_died.connect(show_game_over_screen)

	var final_score = Globals.score
	for key in final_score:
		final_score[key] = 0



func show_game_over_screen():
	game_over.visible = true
