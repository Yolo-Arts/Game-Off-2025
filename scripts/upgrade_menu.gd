extends Control


@onready var stat_up_ui: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer2/Stat_up_UI
@onready var stat_up_ui_2: Stat_ui = $PanelContainer/HBoxContainer/CenterContainer/Stat_up_UI2


@export var stat_up_list: Array[Statup]

var item_table = WeightedTable.new()
var stat_up_index
var stat_up_index2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Globals.player_level_up.connect(_on_player_level_up)
	
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
	Engine.time_scale = 0.1
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

func _on_option_1_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_option_2_pressed() -> void:
	get_tree().paused = false
	visible = false
