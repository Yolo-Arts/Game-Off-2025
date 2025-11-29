extends CanvasLayer
@onready var label: Label = $Control/Label

func _ready() -> void:
	Globals.player_died.connect(show_wasted)

func show_wasted():
	visible = true
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2.ONE, 1.0).from(Vector2.ZERO)
	await get_tree().create_timer(5.0).timeout
	visible = false
