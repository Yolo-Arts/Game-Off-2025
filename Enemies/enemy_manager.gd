extends Node

const SPAWN_RADIUS = 900
var swapper_index = 0

@export var basic_enemy_scene: PackedScene
@export var enemy_types: Array[Resource]

@export var initial_wave_time: float = 20.0 # How long the first wave lasts
@export var time_reduction_per_difficulty: float = 1.0 
var wave_length: float = 20 # Used to define manually how long the wave will be inside the match statement

@onready var timer = $Timer 
@onready var wave_timer = $WaveTimer 
#@onready var wave_time_manager: Node = $"../WaveTimeManager" 

@onready var ENEMY_SPAWN_INDICATOR = preload("uid://dx4o5mretwoae")

var enemy_table = WeightedTable.new()
var rng = RandomNumberGenerator.new()

var enemy_count = 10
var base_spawn_time = 10.0
var spawn_interval: float = 2


# wave tracking
#var enemies_in_current_wave: int = 0
#var enemies_defeated_in_current_wave: int = 0
var difficulty = 0

func _on_isometric_main_begin_game() -> void:
	start_game()

func _ready() -> void:
	enemy_table.add_item(0, 10)

func start_game():
	start_next_wave()

func start_next_wave():
	print("--- Starting Wave ", difficulty + 1, " ---")
	
	#enemies_in_current_wave = enemy_count
	#enemies_defeated_in_current_wave = 0
	
	setup_wave_for_difficulty(difficulty)
	
	#var current_wave_time = initial_wave_time - (difficulty * time_reduction_per_difficulty)
	#current_wave_time = wave_length
	wave_timer.wait_time = wave_length
	wave_timer.start()
	print("Wave timer set to: ", wave_timer.wait_time, " seconds")
	
	spawn_enemy(enemy_count)

func spawn_enemy(enemy_num):
	for i in range(enemy_num):
		spawn()
		await get_tree().create_timer(spawn_interval).timeout

func spawn():
	var enemy_type_index = enemy_table.pick_item()
	var enemy = basic_enemy_scene.instantiate() as Enemy_iso
	#enemy.died.connect(_on_enemy_died)
	
	enemy.set_enemy_type(enemy_type_index)
	enemy.global_position = get_spawn_position()
	
	var instance = ENEMY_SPAWN_INDICATOR.instantiate()
	get_parent().add_child.call_deferred(instance)
	instance.global_position = enemy.global_position
	await get_tree().create_timer(1.7).timeout
	get_parent().add_child.call_deferred(enemy)

#func _on_enemy_died():
	#enemies_defeated_in_current_wave += 1
	#print("Enemy defeated. (", enemies_defeated_in_current_wave, "/", enemies_in_current_wave, ")")


func setup_wave_for_difficulty(current_difficulty: int):
	match current_difficulty:
		0:
			enemy_count = 15
			spawn_interval = 2.0
			wave_length = 30
		1:
			enemy_count = 15
			spawn_interval = 1.5
			wave_length = 20
			
		2, 3, 4, 5:
			enemy_table.add_item(1, 15) 
			enemy_count = 5
			spawn_interval = 0.8
			wave_length = 10
		6:
			enemy_count = 15
			spawn_interval = 0.2
			wave_length = 20
			
		7, 8, 9:
			enemy_table.remove_item(0) 
			enemy_table.add_item(2, 20) 
			enemy_count = 15
			spawn_interval = 0.8
			
		10, 11, 12, 13:
			enemy_table.add_item(3, 10) 
			enemy_count = 18
			spawn_interval = 0.7
			
		14, 15, 16, 17:
			enemy_table.add_item(4, 15) 
			enemy_count = 22
			spawn_interval = 0.6
			
		18, 19, 20:
			enemy_count = 25
			spawn_interval = 0.5
		_:
			enemy_count += 2
			spawn_interval = max(0.4, spawn_interval - 0.05)

func _on_wave_timer_timeout():
	wave_timer.stop() 
	
	difficulty += 1
	Globals.update_score("WAVES_SURVIVED")
	setup_wave_for_difficulty(difficulty)
	
	# After the match, start the next wave
	start_next_wave()

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	if wave_timer.time_left > 0:
		spawn() 


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1 << 3)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position
