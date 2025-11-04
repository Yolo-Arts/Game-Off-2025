extends Node

#level up
var level = 0
var total_exp = 0
var level_threshold = 10

func _ready():
	Globals.exp_collected.connect(_on_exp_collected)
	return

func _process(_delta: float) -> void:
	
	if total_exp >= level_threshold:
		level_up()
		
func level_up():
	level += 1
	# pause game
	# show upgrade options
	# allow player to choose upgrade
	# implement upgrade
	# change level thresholda
	# resume game
	level_threshold = 2*level_threshold
	print("level up")
	return

func _on_exp_collected():
	total_exp += 1
	print(total_exp)
	
	
