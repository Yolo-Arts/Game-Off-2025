extends Node2D
@onready var camera = %Camera2D
@onready var game_over: CanvasLayer = $GameOver
@onready var animation_player = $AnimationPlayer

signal begin_game
var game_began = true

func _ready():
	Globals.unlocked_upgrades = []
	Engine.time_scale = 1.0
	Signals.start_hitStop.connect(hit_stop)
	Globals.camera = camera
	game_over.visible = false
	Globals.player_died.connect(show_game_over_screen)
	animation_player.play('transition')

func _input(event: InputEvent) -> void:
	if game_began:
		if event.is_action_pressed("ui_accept"):
			begin_game.emit()
			game_began = false

func show_game_over_screen():
	game_over.visible = true

func hit_stop(timescale: float, duration: float) -> void:
	if Globals.upgrading == false:
		Engine.time_scale = timescale
		await get_tree().create_timer(duration, true, false, true).timeout
		
		if Globals.upgrading == false:
			Engine.time_scale = 1.0
