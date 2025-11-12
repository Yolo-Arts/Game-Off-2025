extends Node2D
@onready var camera = %Camera2D
@onready var game_over: CanvasLayer = $GameOver
@onready var animation_player = $AnimationPlayer


func _ready():
	Globals.camera = camera
	game_over.visible = false
	Globals.player_died.connect(show_game_over_screen)
	animation_player.play('transition')

func show_game_over_screen():
	game_over.visible = true
