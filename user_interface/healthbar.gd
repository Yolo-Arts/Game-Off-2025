extends CanvasLayer

@onready var player: PackedScene = preload("res://Player/player.tscn")
@onready var health_bar: ProgressBar = %HealthBar


func _process(delta: float) -> void:
	health_bar.value = player.health
