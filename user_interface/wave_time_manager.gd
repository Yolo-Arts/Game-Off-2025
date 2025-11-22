#extends Node
#
#signal difficulty_increased(difficulty: int)
#
#const DIFFICULTY_INTERVAL = 10
#
#@export var end_screen_scene: PackedScene
#
#@onready var timer = $Timer
#
#var difficulty = 0
#var start_time = 0.0
#var game_active = true
#
#
#func _on_isometric_main_begin_game() -> void:
	#timer.start()
#
#func _process(_delta):
	#var next_time_target = timer.wait_time - ((difficulty + 1) * DIFFICULTY_INTERVAL)
	#if timer.time_left <= next_time_target:
		#difficulty += 1
		#difficulty_increased.emit(difficulty)
#
#func get_time_elapsed():
	#return timer.wait_time - timer.time_left
##
###func on_timer_timeout():
	###var end_screen_instance = end_screen_scene.instantiate()
	###add_child(end_screen_instance)
	###end_screen_instance.play_jingle()
#
##extends Node
##
##signal difficulty_increased(difficulty: int)
##signal game_ended(time_elapsed: float)
##
##@export var DIFFICULTY_INTERVAL = 10
##
##@export var end_screen_scene: PackedScene
##
##@onready var timer = $Timer
##
##var difficulty = 0
##var start_time = 0.0
##var game_active = true
##
##func _ready():
	##start_time = Time.get_time_dict_from_system().second
	###timer.start()
##
##func _process(_delta):
	##if not game_active:
		##return
	##
	##var elapsed_time = Time.get_time_dict_from_system().second - start_time
	##
	##var next_difficulty_time = (difficulty + 1) * DIFFICULTY_INTERVAL
	##if elapsed_time >= next_difficulty_time:
		##difficulty += 1
		##difficulty_increased.emit(difficulty)
		##print("difficulty increased")
##
##func get_time_elapsed() -> float:
	##return Time.get_time_dict_from_system().second - start_time
#
##func end_game():
	##if not game_active:
		##return
	##
	##game_active = false
	##timer.stop()
	##
	##var end_screen_instance = end_screen_scene.instantiate()
	##add_child(end_screen_instance)
	##end_screen_instance.play_jingle()
	##game_ended.emit(get_time_elapsed())

extends Node

signal difficulty_increased(difficulty: int)

const DIFFICULTY_INTERVAL = 10

var time_elapsed = 0.0 
var difficulty = 0
var game_active = false 

var next_difficulty_threshold = DIFFICULTY_INTERVAL

func _on_isometric_main_begin_game() -> void:
	game_active = true
	time_elapsed = 0.0
	difficulty = 0
	next_difficulty_threshold = DIFFICULTY_INTERVAL
	# if we want a game over:
	#if $Timer: 
		#$Timer.start()

func _process(delta):
	if not game_active:
		return
	
	time_elapsed += delta
	
	if time_elapsed >= next_difficulty_threshold:
		difficulty += 1
		
		next_difficulty_threshold = (difficulty + 1) * DIFFICULTY_INTERVAL
		
		print("Time: %.2f | Difficulty Increased to: %d" % [time_elapsed, difficulty])
		difficulty_increased.emit(difficulty)

func get_time_elapsed():
	return time_elapsed
