extends Node2D

@onready var camera = %Camera2D

@onready var game_over = $UI/GameOver

func _ready():
	Engine.time_scale = 1.0
	Globals.playerDied = false
	Globals.camera = camera
	
	game_over.visible = false
	Globals.player_died.connect(show_game_over_screen)

	var final_score = Globals.score
	for key in final_score:
		final_score[key] = 0

func show_game_over_screen():
	game_over.visible = true



func hit_stop(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
