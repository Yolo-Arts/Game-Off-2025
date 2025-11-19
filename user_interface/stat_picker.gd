extends Node

@onready var stat_up_ui: Stat_ui = $"../PanelContainer/HBoxContainer/CenterContainer2/Stat_up_UI"
@onready var stat_up_ui_2: Stat_ui = $"../PanelContainer/HBoxContainer/CenterContainer/Stat_up_UI2"

@export var stat_up_list: Array[Statup]

var item_table = WeightedTable.new()
var stat_up_index
var stat_up_index2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player_level_up.connect(_on_player_level_up)
	
	for i in range(stat_up_list.size()):
		item_table.add_item(i, stat_up_list[i].Weight)
	
	stat_up_index = item_table.pick_item()
	stat_up_index2 = item_table.pick_item([stat_up_index])
	stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_player_level_up():
	stat_up_index = item_table.pick_item()
	stat_up_index2 = item_table.pick_item([stat_up_index])
	stat_up_ui.Stat_up = stat_up_list[stat_up_index]
	stat_up_ui_2.Stat_up = stat_up_list[stat_up_index2]
	
