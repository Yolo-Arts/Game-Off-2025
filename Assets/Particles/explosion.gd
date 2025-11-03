extends GPUParticles2D

func _ready():
	$Timer.start(lifetime + 1.0)
	emitting = true

func _on_timer_timeout():
	queue_free()
