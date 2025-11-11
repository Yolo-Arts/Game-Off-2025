extends Node2D
@onready var camera = %Camera2D

func _ready():
	Globals.camera = camera
	#game_over.visible = false
	#Globals.player_died.connect(show_game_over_screen)
