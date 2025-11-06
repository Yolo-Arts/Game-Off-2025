extends Node

var camera

var player_health: float = 5

var playerDied = false

signal player_died

var my_timer: Timer = Timer.new()
const INTERVAL: float = 1
var score = {
	"PER_SECOND_SURVIVED":0,
	"ENEMY_SHIPWRECKED":0,
	"BOUNTY_POINT":0,
	"WAVES_SURVIVED":0, 
	"BOSSES_SHIPWRECKED":0
}

var UserInterface

enum POINTS_CATEGORIES  {
	PER_SECOND_SURVIVED = 2,
	ENEMY_SHIPWRECKED = 50,
	BOUNTY_POINT = 100,
	WAVES_SURVIVED = 100, 
	BOSSES_SHIPWRECKED = 250
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
		print("Final Score %s" % score)
		
func _on_my_timer_timeout():
	update_score("PER_SECOND_SURVIVED")

func update_score(points_scored_category):
	score[points_scored_category] += POINTS_CATEGORIES[points_scored_category]
