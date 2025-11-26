extends CanvasLayer

@onready var hp: CanvasLayer = $HP
@onready var drift_bar: CanvasLayer = $DriftBar
@onready var experience_bar: CanvasLayer = $ExperienceBar



func _ready() -> void:
	visible = false
	hp.visible = false
	drift_bar.visible = false
	experience_bar.visible = false


func _on_isometric_main_begin_game() -> void:
	visible = true
	hp.visible = true
	drift_bar.visible = true
	experience_bar.visible = true
