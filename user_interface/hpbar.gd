extends CanvasLayer

# Base Icon does nothing.

@export var player_manager: Node
@onready var health_progress: TextureProgressBar = $Control/HealthProgress
@onready var heart_icon: TextureProgressBar = $Control/HeartIcon
@onready var level_progress: TextureProgressBar = $Control/LevelProgress

var player: Iso_player

func _ready():
	level_progress.value = 0.0
	player = get_tree().get_first_node_in_group("player") as Iso_player


func _process(delta: float) -> void:
	health_progress.value = player.health
	heart_icon.value = player.health
	health_progress.max_value = player.player_max_health
	heart_icon.max_value = player.player_max_health
	#hp_label.text = "HP: " + str(player.health)


func _on_player_manager_exp_updated(current_exp: float, target_exp: float) -> void:
	var percent = current_exp / target_exp
	level_progress.value = percent
