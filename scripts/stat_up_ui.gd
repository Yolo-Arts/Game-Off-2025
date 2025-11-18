class_name Stat_ui
extends Control

@export var Stat_up: Statup


@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var button: Button = $VBoxContainer/Button
@onready var description: Label = $VBoxContainer/Description

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up variables and grab player from group
	var stat_up_image = Stat_up.image
	var stat_up_name = Stat_up.name
	var stat_up_description = Stat_up.description
	player = get_tree().get_first_node_in_group("player")
	texture_rect.texture = stat_up_image
	button.text = stat_up_name
	description.text = stat_up_description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass     

func _on_button_pressed() -> void:
	SoundManager.play_UpgradeUnlock()
	# pause game and allow options to choose from
	if get_tree().paused == true:
		get_tree().paused = false
		Stat_up.apply_upgrade(player)
		get_tree().get_first_node_in_group("Upgrade_UI").visible = false 


func _on_button_mouse_entered() -> void:
	SoundManager.UI_ButtonHovered()
