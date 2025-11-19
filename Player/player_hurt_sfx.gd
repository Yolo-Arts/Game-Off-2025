extends AudioStreamPlayer2D

# FIXME Delete this if not used: SoundManager Refactoring.

#@export var hurt_SFX: Resource
#@export var min_pitch: float = 0.5
#@export var max_pitch: float = 3
#
#var rng = RandomNumberGenerator.new()
#
#func _on_player_player_hit_sfx():
	#rng.randomize()
	#
	#if hurt_SFX:
		#var random_index = rng.randi_range(0, hurt_SFX.sounds.size() - 1)
		#var random_sound = hurt_SFX.sounds[random_index]
		#stream = random_sound
		#
		#pitch_scale = rng.randf_range(min_pitch, max_pitch)
		#
		#play()
	#else:
		#return
#
#
#func _on_player_isometric_player_hit_sfx():
	#pass # Replace with function body.
