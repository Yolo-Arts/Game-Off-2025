extends CanvasLayer

# Base Icon does nothing.

@export var player_manager: Node
@onready var health_progress: TextureProgressBar = %HealthProgress
@onready var heart_icon: TextureProgressBar = %HeartIcon
@onready var level_progress: TextureProgressBar = %LevelProgress
@onready var shaker: Shaker = $Shaker
@onready var hp_particles: GPUParticles2D = $Control/BaseIcon/HpParticles
@onready var low_hp_vignette: ColorRect = $lowHPVignette
@onready var playheart_beat: Timer = $playheartBeat

var player: Iso_player

func _ready():
	low_hp_vignette.visible = false
	level_progress.value = 0.0
	player = get_tree().get_first_node_in_group("player") as Iso_player


func _process(delta: float) -> void:
	health_progress.value = player.health
	heart_icon.value = player.health
	health_progress.max_value = player.player_max_health
	heart_icon.max_value = player.player_max_health
	#hp_label.text = "HP: " + str(player.health)
	
	if health_progress.value < health_progress.max_value * 0.25 && health_progress.value > 0:
		low_hp_vignette.visible = true
		shaker.start()
		hp_particles.emitting = true
	else: 
		SoundManager.play_bgm()
		SoundManager.stop_heartBeat()
		low_hp_vignette.visible = false
		hp_particles.emitting = false



func _on_player_manager_exp_updated(current_exp: float, target_exp: float) -> void:
	var percent = current_exp / target_exp
	level_progress.value = percent


func _on_player_isometric_shake_hp_bar() -> void:
	print("HP BAR SHAKEN")
	shaker.start()

func _on_playheart_beat_timeout() -> void:
	if health_progress.value <= health_progress.max_value * 0.30 && health_progress.value > 0:
		SoundManager.stop_bgm_heartBeat()
		SoundManager.start_heartBeat()
		low_hp_vignette.visible = true
		shaker.start()
		hp_particles.emitting = true
	else: 
		SoundManager.play_bgm_heartbeat()
		SoundManager.stop_heartBeat()
		low_hp_vignette.visible = false
		hp_particles.emitting = false
