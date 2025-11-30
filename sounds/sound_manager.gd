extends Node

@onready var cannon_fire = $CannonFire
@onready var death_explosions = $DeathExplosions
@onready var enemy_hit = $EnemyHit
@onready var player_hurt_sfx = $PlayerHurtSFX
@onready var button_pressed: AudioStreamPlayer = $UI_SFX/ButtonPressed
@onready var button_hover: AudioStreamPlayer = $UI_SFX/ButtonHover
@onready var upgrade_unlock: AudioStreamPlayer = $UpgradeUnlock
@onready var level_up: AudioStreamPlayer = $LevelUp
@onready var reload: AudioStreamPlayer = $Reload
@onready var bgm_1: AudioStreamPlayer = $bgm
@onready var load_cassette: AudioStreamPlayer = $Load_Cassette
@onready var remove_cassette: AudioStreamPlayer = $Remove_Cassette
@onready var music_stop: AudioStreamPlayer = $Music_Stop
@onready var score_hit: AudioStreamPlayer = $Score_Hit
@onready var heart_beat: AudioStreamPlayer = $HeartBeat
@onready var enemy_cannon_ball_hit_but_player_is_drifting: AudioStreamPlayer = $EnemyCannonBallHitButPlayerIsDrifting
@onready var war_horn: AudioStreamPlayer = $WarHorn


func play_CannonFire():
	cannon_fire.play()

func play_DeathExplosions():
	death_explosions.play()

func play_EnemyHit():
	enemy_hit.play()

func play_PlayerHurt():
	player_hurt_sfx.play()

func UI_ButtonPressed():
	button_pressed.play()

func UI_ButtonHovered():
	button_hover.play()

func play_UpgradeUnlock():
	upgrade_unlock.play()

func play_LevelUp():
	level_up.play()

func play_reload():
	reload.play()

func play_load_cassette():
	load_cassette.play()

func play_remove_casette():
	remove_cassette.play()

func start_bgm():
	bgm_1.play()

func play_bgm():
	var bus_index = AudioServer.get_bus_index("BGM")
	
	AudioServer.get_bus_effect(bus_index, 0)
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)

func stop_bgm():
	var bus_index = AudioServer.get_bus_index("BGM")
	print("Bus index:", bus_index)
	
	AudioServer.get_bus_effect(bus_index, 0)
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)



func apply_bgm_filter():
	var bus_index = AudioServer.get_bus_index("BGM")
	AudioServer.get_bus_effect(bus_index, 1)
	AudioServer.set_bus_effect_enabled(bus_index, 1, true)

func remove_bgm_filter():
	var bus_index = AudioServer.get_bus_index("BGM")
	AudioServer.get_bus_effect(bus_index, 1)
	AudioServer.set_bus_effect_enabled(bus_index, 1, false)

func play_lose_game():
	bgm_1.stream_paused = true
	music_stop.play()

func play_scoreHit():
	score_hit.play()
	

func start_heartBeat():
	heart_beat.play()
	heart_beat.stream_paused = false

func stop_heartBeat():
	heart_beat.stream_paused = true
	

func play_enemyCannonBallHitButPlayerIsDrifting():
	enemy_cannon_ball_hit_but_player_is_drifting.play()

func play_warHorn():
	war_horn.play()
