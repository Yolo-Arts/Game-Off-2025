extends GPUParticles2D


@onready var parent = get_parent()

func _process(delta: float) -> void:
	position = parent.global_position + Vector2(0, 18)


func _on_player_isometric_boost() -> void:
	emitting = true
