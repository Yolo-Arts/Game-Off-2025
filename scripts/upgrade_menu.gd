extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player_level_up.connect(_on_player_level_up)


func _on_player_level_up():
	SoundManager.play_LevelUp()
	get_tree().paused = true    
	visible = true  

func _on_option_1_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_option_2_pressed() -> void:
	get_tree().paused = false
	visible = false
