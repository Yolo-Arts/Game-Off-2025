extends CanvasLayer

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var shaker: Shaker = $Shaker
@onready var shaker_2: Shaker = $Shaker2



#@onready var progress_bar: TextureProgressBar = $Control/TextureProgressBar
#@onready var progress_bar: TextureProgressBar = %TextureProgressBar

var player: Iso_player
signal player_can_drift

func _ready():
	player = get_tree().get_first_node_in_group("player") as Iso_player


func _process(delta: float) -> void:
	progress_bar.value += 20 * delta
	
	if progress_bar.value > 90:
		shaker.start()
		shaker_2.start()
		gpu_particles_2d.emitting = true
	else:
		shaker.stop()
		shaker_2.stop()
		gpu_particles_2d.emitting = false
	
	if progress_bar.value >= 100:
		player_can_drift.emit()


func _on_player_isometric_reset_drift_cooldown_bar() -> void:
	progress_bar.value = 0
