extends Control

@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var shaker: Shaker = $Shaker

func _ready():
	label.self_modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(label, "self_modulate:a", 1.0, 0.2)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_property(label, "self_modulate:a", 0.0, 0.7)
	

func _on_timer_timeout() -> void:
	queue_free()
