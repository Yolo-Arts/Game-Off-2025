extends Node2D
@onready var camera = %Camera2D
@onready var game_over: CanvasLayer = $GameOver
@onready var animation_player = $AnimationPlayer


func _ready():
	Engine.time_scale = 1.0
	Signals.start_hitStop.connect(hit_stop)
	Globals.camera = camera
	game_over.visible = false
	Globals.player_died.connect(show_game_over_screen)
	animation_player.play('transition')

func show_game_over_screen():
	game_over.visible = true

func hit_stop(timescale: float, duration: float) -> void:
	if Globals.upgrading == false:
		Engine.time_scale = timescale
		await get_tree().create_timer(duration, true, false, true).timeout
		Engine.time_scale = 1.0
