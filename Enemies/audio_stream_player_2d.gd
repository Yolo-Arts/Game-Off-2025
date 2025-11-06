extends AudioStreamPlayer2D

@export var explosion_sounds: Resource
@export var min_pitch: float = 0.5
@export var max_pitch: float = 3

var rng = RandomNumberGenerator.new()

func _on_basic_enemy_play_sound():
	rng.randomize()
	
	if explosion_sounds:
		var random_index = rng.randi_range(0, explosion_sounds.sounds.size() - 1)
		var random_sound = explosion_sounds.sounds[random_index]
		stream = random_sound
		
		pitch_scale = rng.randf_range(min_pitch, max_pitch)
		
		play()
	else:
		return
