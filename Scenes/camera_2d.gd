extends Camera2D

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

var normal_zoom: Vector2 = Vector2(0.5, 0.5)
var max_zoom_in: Vector2 = Vector2(0.65, 0.65)
var max_zoom_out: Vector2 = Vector2(0.45, 0.45)

var zoom_tween: Tween

func _ready():
	zoom = normal_zoom
	set_process(true)

# Shake with decreasing intensity while there's time remaining.
func _process(delta):
	# Only shake when there's shake time remaining.
	if _timer == 0:
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = randf_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = randf_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(get_offset() - _last_offset)

# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
	if frequency == 0: return
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = randf_range(-1.0, 1.0)
	_previous_y = randf_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)


func _on_player_isometric_zoom_in() -> void:
	start_camera_tween(max_zoom_in, 1.5)

func _on_player_isometric_zoom_out() -> void:
	if zoom_tween and zoom_tween.is_running():
		zoom_tween.kill()
	
	zoom_tween = create_tween()
	zoom_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	zoom_tween.tween_property(self, "zoom", max_zoom_out, 1)
	zoom_tween.tween_property(self, "zoom", normal_zoom, 0.5)
	
	


func start_camera_tween(target_zoom: Vector2, duration: float):
	if zoom_tween and zoom_tween.is_running():
		zoom_tween.kill()
	
	zoom_tween = create_tween()
	zoom_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	zoom_tween.tween_property(self, "zoom", target_zoom, duration)
