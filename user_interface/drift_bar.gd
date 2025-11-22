extends CanvasLayer


@onready var progress_bar: ProgressBar = $Control/ProgressBar
#@onready var progress_bar: TextureProgressBar = $Control/TextureProgressBar
#@onready var progress_bar: TextureProgressBar = %TextureProgressBar

var player: Iso_player
signal player_can_drift

func _ready():
	player = get_tree().get_first_node_in_group("player") as Iso_player


func _process(delta: float) -> void:
	progress_bar.value += 20 * delta
	
	if progress_bar.value >= 100:
		player_can_drift.emit()


func _on_player_isometric_reset_drift_cooldown_bar() -> void:
	progress_bar.value = 0
