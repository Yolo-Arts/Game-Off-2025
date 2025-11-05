extends Node

var camera

var player_health: float = 5

var playerDied = false

signal player_died

var my_timer: Timer = Timer.new()
const INTERVAL: float = 1

var UserInterface

enum POINTS_CATEGORIES  {
	PER_SECOND_SURVIVED = 2,
	ENEMY_SHIPWRECKED = 50
}

func _ready() -> void:
	UserInterface = get_parent().get_node("Main").get_node("UserInterface")
	my_timer.wait_time = INTERVAL
	my_timer.autostart = true
	my_timer.one_shot = false # Set to true if you only need it to fire once
	
	# 2. Add the timer to the scene tree (the Autoload is already in the tree)
	add_child(my_timer)
	
	# 3. Connect the timeout signal to your function
	my_timer.timeout.connect(_on_my_timer_timeout)
	
func _process(delta):
	if player_health < 0 && playerDied == false:
		print("player died")
		player_died.emit()
		playerDied = true
		flag = false
		
func _on_my_timer_timeout():
	UserInterface.get_node("ScoreLabel")._update_score(POINTS_CATEGORIES.PER_SECOND_SURVIVED)
	
