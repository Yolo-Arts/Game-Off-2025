extends Node

@onready var cannon_fire = $CannonFire
@onready var death_explosions = $DeathExplosions
@onready var enemy_hit = $EnemyHit
@onready var player_hurt_sfx = $PlayerHurtSFX
@onready var button_pressed: AudioStreamPlayer = $UI_SFX/ButtonPressed
@onready var button_hover: AudioStreamPlayer = $UI_SFX/ButtonHover
@onready var upgrade_unlock: AudioStreamPlayer = $UpgradeUnlock
@onready var level_up: AudioStreamPlayer = $LevelUp



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
