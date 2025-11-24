extends CanvasLayer

@onready var hp: CanvasLayer = $HPbarAndEXPBar
@onready var drift_bar: CanvasLayer = $DriftBar



func _ready() -> void:
	visible = false
	hp.visible = false
	drift_bar.visible = false
	


func _on_isometric_main_begin_game() -> void:
	await get_tree().create_timer(0.5).timeout
	visible = true
	hp.visible = true
	drift_bar.visible = true
