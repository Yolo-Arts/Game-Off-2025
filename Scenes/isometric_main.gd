extends Node2D
@onready var camera = %Camera2D
@onready var game_over: CanvasLayer = $GameOver
@onready var animation_player = $AnimationPlayer
@onready var drift_bar: CanvasLayer = $UI/DriftBar
@onready var wasted_label: CanvasLayer = $UI/WastedLabel
@onready var upgrade_menu_ui: CanvasLayer = $Upgrade_menu_UI

signal begin_game
var game_began = true

func _ready():
	var score = Globals.score
	score["PER_SECOND_SURVIVED"] = 0
	score["ENEMY_SHIPWRECKED"] = 0
	score["BOUNTY_POINT"] = 0
	score["WAVES_SURVIVED"] = 0
	score["BOSSES_SHIPWRECKED"] = 0
	Globals.unlocked_upgrades = []
	Engine.time_scale = 1.0
	Signals.start_hitStop.connect(hit_stop)
	Globals.camera = camera
	Globals.camera.zoom = Vector2(1.5, 1.5)
	game_over.visible = false
	wasted_label.visible = false
	Globals.player_died.connect(show_game_over_screen)
	animation_player.play('transition')
	SoundManager.start_bgm()

func _input(event: InputEvent) -> void:
	if game_began:
		if event.is_action_pressed("ui_accept"):
			game_began = false
			begin_game.emit()
			var tween = create_tween()
			tween.tween_property(Globals.camera, "zoom", Vector2(0.7, 0.7), 0.7)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			await get_tree().create_timer(.7).timeout

func show_game_over_screen():
	#Globals.camera.zoom = Vector2(3.0, 3.0) 
	upgrade_menu_ui.visible = false
	drift_bar.visible = false
	await get_tree().create_timer(5.0).timeout
	game_over.visible = true

func hit_stop(timescale: float, duration: float) -> void:
	if Globals.upgrading == false:
		Engine.time_scale = timescale
		await get_tree().create_timer(duration, true, false, true).timeout
		
		if Globals.upgrading == false:
			Engine.time_scale = 1.0
