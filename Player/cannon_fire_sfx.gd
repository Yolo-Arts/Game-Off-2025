extends AudioStreamPlayer2D

@export var min_pitch: float = 0.5
@export var max_pitch: float = 3

var rng = RandomNumberGenerator.new()

func _on_player_fire_cannon_sfx():
	pitch_scale = rng.randf_range(min_pitch, max_pitch)
	play()
