extends Node

#level up
var level = 0
var total_exp = 0
var level_threshold = 10

func ready():
	pass

func _process(_delta: float) -> void:
	
	if total_exp >= level_threshold:
		level_up()
		
func level_up():
	level += 1
	# pause game
	# show upgrade options
	# allow player to choose upgrade
	# implement upgrade
	# resume game
	return
