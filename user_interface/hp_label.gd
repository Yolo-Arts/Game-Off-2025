extends Label
@onready var player: Player = %Player

func _on_ready():
	
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	
	text = "hp: " + str(player.health)
