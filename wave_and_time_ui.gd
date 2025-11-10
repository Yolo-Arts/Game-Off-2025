extends CanvasLayer

@export var wave_time_manager: Node
@onready var label = %Label

func _process(delta):
	if wave_time_manager == null:
		return
	var time_elapsed = wave_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float) -> String:
	if seconds < 0:
		seconds = 0
	
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	
	# Formatted as MM:SS
	return "%d:%02d" % [minutes, remaining_seconds]
