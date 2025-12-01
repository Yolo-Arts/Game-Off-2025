extends Control

@onready var stat_up_ui: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer2/Stat_up_UI
@onready var stat_up_ui_2: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer/Stat_up_UI2

# TODO when music is implemented, add an audio effect to change the way it sounds during an upgrade
@export var stat_up_list: Array[Statup]

@export var hotbar: HBoxContainer

var item_table = WeightedTable.new()
var stat_up_index
var stat_up_index2
var selected = true
const MAX_ABILITIES = 3
const MAX_BULLET_TYPES = 3

func _ready() -> void:
	visible = false
	Globals.player_level_up.connect(_on_player_level_up)
	
	stat_up_ui.upgrade_selected.connect(_on_card_selected)
	stat_up_ui_2.upgrade_selected.connect(_on_card_selected)
	
	for upgrade in stat_up_list:
		item_table.add_item(upgrade, upgrade.Weight)
	
	#stat_up_index = item_table.pick_item()
	#stat_up_index2 = item_table.pick_item([stat_up_index])
	#stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	#stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]
	
	stat_up_ui.Stat_up = item_table.pick_item()
	stat_up_ui_2.Stat_up = item_table.pick_item([stat_up_ui.Stat_up])
	
	stat_up_ui.update()
	stat_up_ui_2.update()

func _process(_delta):
	pass

func _on_player_level_up():
	Globals.upgrading = true
	SoundManager.stop_bgm()
	SoundManager.play_LevelUp()
	Engine.time_scale = 0.05
	
	#item_table = WeightedTable.new()
	#
	#for i in range(stat_up_list.size()):
		#var current_upgrade = stat_up_list[i]
		#if not Globals.unlocked_upgrades.has(current_upgrade):
			#item_table.add_item(i, current_upgrade.Weight)
	
	#stat_up_index = item_table.pick_item()
	#stat_up_index2 = item_table.pick_item([stat_up_index])
	#stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	#stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]
	
	stat_up_ui.Stat_up = item_table.pick_item()
	stat_up_ui_2.Stat_up = item_table.pick_item([stat_up_ui.Stat_up])
	
	stat_up_ui.update()
	stat_up_ui_2.update()
	stat_up_ui.animation_player.play("in")
	stat_up_ui_2.animation_player.play("in")
	
	#get_tree().paused = true    
	visible = true  
	await get_tree().create_timer(0.05).timeout
	stat_up_ui.selected = false
	stat_up_ui_2.selected = false
	selected = false

#func _on_option_1_pressed() -> void:
	#apply_upgrade(stat_up_list[stat_up_index])
	#get_tree().paused = false
	#visible = false
#
#
#func _on_option_2_pressed() -> void:
	#apply_upgrade(stat_up_list[stat_up_index])
	#get_tree().paused = false
	#visible = false

func _on_card_selected(upgrade: Statup):
	selected = true
	await get_tree().create_timer(0.05).timeout
	Engine.time_scale= 1.0
	if upgrade.type == "Ability":
		Globals.unlocked_abilities.append(upgrade)
		item_table.remove_item(upgrade)
		if Globals.unlocked_abilities.size() >= MAX_ABILITIES:
			remove_other_abilities(Globals.unlocked_abilities)
		
	if upgrade.type == "Bullet Type" and !Globals.active_cannonball_upgrades.has(upgrade):
		Globals.active_cannonball_upgrades.append(upgrade)
		Globals.active_cannonball_upgrades.sort_custom(sort_cannonball_upgrades)
		if Globals.active_cannonball_upgrades.size() >= MAX_BULLET_TYPES:
			remove_other_bullet_types(Globals.active_cannonball_upgrades)
	elif upgrade.type == "Bullet Type" and Globals.active_cannonball_upgrades.has(upgrade):
		upgrade.upgrade_self()
	apply_upgrade(upgrade)
	visible = false
	Globals.upgrading = false

func apply_upgrade(upgrade: Statup):
	SoundManager.play_bgm()
	if upgrade is Ability and hotbar:
		hotbar.unlock_ability(upgrade)
	else:
		upgrade.apply_upgrade(Globals.player)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("turn_left") and !selected:
		stat_up_ui.select_upgrade()
		stat_up_ui_2.selected = true
		selected = true
	if event.is_action_pressed("turn_right") and !selected:
		stat_up_ui_2.select_upgrade()
		stat_up_ui.selected = true
		selected = true

func remove_other_bullet_types(unlocked_bullet_types: Array[Statup]):
	
	var removal_list = []
	for upgrade in stat_up_list:
		if upgrade.type == "Bullet Type" and !unlocked_bullet_types.has(upgrade):
			removal_list.append(upgrade)
	
	for item in removal_list:
		item_table.remove_item(item)
	pass
	
func remove_other_abilities(Unlocked_abilities: Array[Statup]):
	var removal_list = []
	for upgrade in stat_up_list:
		
		if upgrade.type == "Ability" and !Unlocked_abilities.has(upgrade):
			removal_list.append(upgrade)
	
	for item in removal_list:
		item_table.remove_item(item)
	pass

func sort_cannonball_upgrades(cannonball_upgrade1: cannon_ball_upgrade, cannonball_upgrade2:cannon_ball_upgrade):
	
	
	if cannonball_upgrade1.cannonball_upgrade_type == "number_altering" and cannonball_upgrade2.cannonball_upgrade_type != "number_altering":
		return true
	return false
