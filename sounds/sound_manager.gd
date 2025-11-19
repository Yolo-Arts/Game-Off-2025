extends Node

@onready var cannon_fire = $CannonFire
@onready var death_explosions = $DeathExplosions
@onready var enemy_hit = $EnemyHit
@onready var player_hurt_sfx = $PlayerHurtSFX

func play_CannonFire():
	cannon_fire.play()

func play_DeathExplosions():
	death_explosions.play()

func play_EnemyHit():
	enemy_hit.play()

func play_PlayerHurt():
	player_hurt_sfx.play()
