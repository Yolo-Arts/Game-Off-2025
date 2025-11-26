extends CanvasLayer

@export var player_manager: Node
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar


func _ready():
	progress_bar.value = 0

func _on_player_manager_exp_updated(current_exp: float, target_exp: float) -> void:
	var percent = current_exp / target_exp
	progress_bar.value = percent
