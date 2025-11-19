extends CanvasLayer

#@onready var player: PackedScene = preload("res://Player/player_isometric.tscn")
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var hp_label = $Control/HealthBar/hpLabel

var player: Iso_player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Iso_player

#
func _process(delta: float) -> void:
	health_bar.value = player.health
	hp_label.text = "HP: " + str(player.health)
