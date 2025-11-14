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
	player = get_tree().get_first_node_in_group("player")
	texture_rect.texture = Stat_up.image
	button.text = Stat_up.name
	description.text = Stat_up.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass     

func _on_button_pressed() -> void:
	# pause game and allow options to choose from
	if get_tree().paused == true:
		get_tree().paused = false
		Stat_up.apply_upgrade(player)
		get_tree().get_first_node_in_group("Upgrade_UI").visible = false 
		
func update():
	texture_rect.texture = Stat_up.image
	button.text = Stat_up.name
	description.text = Stat_up.description
