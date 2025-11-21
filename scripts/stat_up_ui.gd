class_name Stat_ui
extends Control

@export var Stat_up: Statup

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation: AnimationPlayer = $HoverAnimation

@onready var texture_rect: TextureRect = %TextureRect
#@onready var button: Button = %Button
@onready var description: Label = %Description

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.upgrading = true
	animation_player.play("in")
	# set up variables and grab player from group
	player = get_tree().get_first_node_in_group("player")
	texture_rect.texture = Stat_up.image
	#button.text = Stat_up.name
	description.text = Stat_up.description 

#func _on_button_pressed() -> void:
	#SoundManager.play_UpgradeUnlock()
	## pause game and allow options to choose from
	#if get_tree().paused == true:
		#get_tree().paused = false
		#Stat_up.apply_upgrade(player)
		#get_tree().get_first_node_in_group("Upgrade_UI").visible = false 


func _on_button_mouse_entered() -> void:
	SoundManager.UI_ButtonHovered()
		
func update():
	texture_rect.texture = Stat_up.image
	#button.text = Stat_up.name
	description.text = Stat_up.description


func select_upgrade():
	SoundManager.play_UpgradeUnlock()
	
	for other_card in get_tree().get_nodes_in_group("upgrade"):
		if other_card == self:
			continue
		other_card.play_discard()
		
	if Engine.time_scale < 1.0:
		animation_player.speed_scale = 1.0 / Engine.time_scale
	else:
		animation_player.speed_scale = 1.0
	
	animation_player.play("selected_discard")
	await get_tree().create_timer(0.1).timeout
	Engine.time_scale= 1.0
	
	#print("animation finished")
	
	# pause game and allow options to choose from
	#if get_tree().paused == true:
		#get_tree().paused = false
		#Stat_up.apply_upgrade(player)
		#get_tree().get_first_node_in_group("Upgrade_UI").visible = false 
	Stat_up.apply_upgrade(player)
	get_tree().get_first_node_in_group("Upgrade_UI").visible = false 
	Globals.upgrading = false

func play_discard():
	animation_player.play("out")

func _on_panel_mouse_entered() -> void:
	hover_animation.play("hover")


func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_upgrade()
	
