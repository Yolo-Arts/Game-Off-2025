extends Control

@onready var stat_up_ui: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer2/Stat_up_UI
@onready var stat_up_ui_2: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer/Stat_up_UI2

# TODO when music is implemented, add an audio effect to change the way it sounds during an upgrade

@export var stat_up_list: Array[Statup]
@export var hotbar: HBoxContainer

var item_table = WeightedTable.new()
var stat_up_index
var stat_up_index2


func _ready() -> void:
	visible = false
	Globals.player_level_up.connect(_on_player_level_up)
	
	stat_up_ui.upgrade_selected.connect(_on_card_selected)
	stat_up_ui_2.upgrade_selected.connect(_on_card_selected)
	
	for i in range(stat_up_list.size()):
		item_table.add_item(i, stat_up_list[i].Weight)
	
	stat_up_index = item_table.pick_item()
	stat_up_index2 = item_table.pick_item([stat_up_index])
	stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]
	
	stat_up_ui.update()
	stat_up_ui_2.update()

func _on_player_level_up():
	Globals.upgrading = true
	SoundManager.play_LevelUp()
	Engine.time_scale = 0.05
	
	item_table = WeightedTable.new()
	
	for i in range(stat_up_list.size()):
		var current_upgrade = stat_up_list[i]
		if not Globals.unlocked_upgrades.has(current_upgrade):
			item_table.add_item(i, current_upgrade.Weight)
	
	stat_up_index = item_table.pick_item()
	stat_up_index2 = item_table.pick_item([stat_up_index])
	stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]
	
	stat_up_ui.update()
	stat_up_ui_2.update()
	stat_up_ui.animation_player.play("in")
	stat_up_ui_2.animation_player.play("in")
	
	#get_tree().paused = true    
	visible = true  

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
	if upgrade.is_unique:
		Globals.unlocked_upgrades.append(upgrade)
	
	apply_upgrade(upgrade)
	visible = false
	Globals.upgrading = false

func apply_upgrade(upgrade: Statup):
	if upgrade is Ability and hotbar:
		print("path 1")
		hotbar.unlock_ability(upgrade)
	else:
		print("Path 2")
		upgrade.apply_upgrade(Globals.player)
