extends GPUParticles2D

@onready var sound = $AudioStreamPlayer2D
@onready var timer = $Timer


func _ready():
	if sound:
		sound.pitch_scale *= randf_range(0.9, 1.1)
		sound.play()
	timer.start()
	self.emitting = true


func _on_timer_timeout():
	queue_free()
