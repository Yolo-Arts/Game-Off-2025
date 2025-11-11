extends Node

const SPAWN_RADIUS = 700
var swapper_index = 0

@export var basic_enemy_scene: PackedScene
@export var enemy_types: Array[Resource]
var enemy_stats: Resource
@onready var timer = $Timer
@onready var wave_time_manager: Node = $"../WaveTimeManager"

@onready var ENEMY_SPAWN_INDICATOR = preload("uid://dx4o5mretwoae")

var enemy_table = WeightedTable.new()

var rng = RandomNumberGenerator.new()

var enemy_count = 2
var base_spawn_time

func _ready():
	base_spawn_time = timer.wait_time
	# This code adds the index of the enemy type to the enemy_table
	# First param = index
	# Second param is the weight or probability of appearing
	# So if the total weight of items in the enemy table is 100
	# And enemy with index 5 has a weight of 50
	# The enemy with index will have a  50% chance of spawning.
	enemy_table.add_item(0, 10)
	enemy_table.add_item(1, 10)
	
	spawn_enemy(enemy_count)
	
	wave_time_manager.difficulty_increased.connect(on_difficulty_increased)

func spawn_enemy(enemy_num):
	for i in range(enemy_num):
		spawn()
		await get_tree().create_timer(0.2).timeout

func spawn():
		var enemy_type_index = enemy_table.pick_item()
		var enemy = basic_enemy_scene.instantiate() as Enemy
		
		enemy.set_enemy_type(enemy_type_index)
		enemy.global_position = get_spawn_position()
		
		#TODO Add a spawn animation for enemy to give the player a chance before they get absolutely jumped.
		 #add 0.5 second delay before spawning
		var instance = ENEMY_SPAWN_INDICATOR.instantiate()
		get_parent().add_child.call_deferred(instance)
		instance.global_position = enemy.global_position
		await get_tree().create_timer(1.7).timeout
		#await get_tree().create_timer(0.2).timeout
		get_parent().add_child.call_deferred(enemy)

func on_difficulty_increased(difficulty: int):
	print("current difficulty: ",difficulty)
	print("number of enemies spawned: ", enemy_count)
	
	match difficulty:
		1:
			pass
		2:
			enemy_table.add_item(2, 10)
		3:
			enemy_count += 1
		4:
			enemy_table.remove_item(0)
		5:
			enemy_count += 1
		_:
			enemy_count += 1
	
	
	var time_off = 0.2 * difficulty
	time_off = min(time_off, 8.0)  
	timer.wait_time = base_spawn_time - time_off
	print(base_spawn_time - time_off)
	timer.start()

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	spawn_enemy(enemy_count)
	
	#enemy.set_enemy_type(swapper_index)
	#
	#if swapper_index == 0:
		#swapper_index = 1
	#else: 
		#swapper_index = 0

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
