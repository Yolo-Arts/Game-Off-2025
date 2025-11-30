extends Node

const SPAWN_RADIUS = 900
var swapper_index = 0

@export var basic_enemy_scene: PackedScene
@export var dash_enemy_scene: PackedScene
@export var projectile_enemy_scene: PackedScene

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
@onready var start_container: HBoxContainer = %StartContainer
@onready var star_1: TextureRect = %Star1
@onready var star_2: TextureRect = %Star2
@onready var star_3: TextureRect = %Star3
@onready var star_4: TextureRect = %Star4
@onready var star_5: TextureRect = %Star5

@onready var next_wave_label: Label = $WaveUI/DifficultyIncreased/NextWaveLabel


# wave tracking
#var enemies_in_current_wave: int = 0
#var enemies_defeated_in_current_wave: int = 0
var difficulty = 0

func _on_isometric_main_begin_game() -> void:
	start_game()

func _ready() -> void:
	next_wave_label.visible = false
	for i in start_container.get_children():
		i.visible = false
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
	var enemy_stats = enemy_types[enemy_type_index]
	var enemy_scene = basic_enemy_scene
	if enemy_stats.can_dash:
		print("Enemy can dash")
		enemy_scene = dash_enemy_scene
	elif enemy_stats.can_shoot:
		enemy_scene = projectile_enemy_scene
	
	var enemy = enemy_scene.instantiate() as Enemy_iso
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
			SoundManager.play_warHorn()
			enemy_count = 10
			spawn_interval = 3
			wave_length = 30
		1:
			enemy_count = 10
			spawn_interval = 1.5
			wave_length = 20
			
		2:
			star_1.visible = true
			show_next_wave_text()
			Globals.update_score("BOUNTY_POINT")
			enemy_table.add_item(1, 15) # Add red boat
			enemy_count = 7
			spawn_interval = 0.8
			wave_length = 10
		3, 4, 5:
			enemy_count = 5
			spawn_interval = 0.8
			wave_length = 10
		6:
			star_2.visible = true
			show_next_wave_text()
			Globals.update_score("BOUNTY_POINT")
			enemy_table.add_item(2, 20)  # Add green boat
			enemy_table.add_item(5, 15) # Dash enemy (purple)
			enemy_count = 18
			spawn_interval = 0.2
			wave_length = 30
			
		7:
			enemy_count = 25
			spawn_interval = 1.0
		8:
			star_3.visible = true
			show_next_wave_text()
			Globals.update_score("BOUNTY_POINT")
			enemy_table.remove_item(0) # Remove black boat
			enemy_table.add_item(6, 15) # Projectile enemy (orange)
			enemy_count = 25
			spawn_interval = 1.0
		9:
			enemy_count = 25
			spawn_interval = 1.0
		10:
			star_4.visible = true
			show_next_wave_text()
			Globals.update_score("BOUNTY_POINT")
			enemy_table.remove_item(1) 
			enemy_table.add_item(3, 10) 
			enemy_count = 25
			spawn_interval = 1
			wave_length = 25
		11, 12:
			enemy_count = 25
			spawn_interval = 1
			wave_length = 25
		13:
			star_5.visible = true
			show_next_wave_text()
			Globals.update_score("BOUNTY_POINT")
			enemy_count = 30
			spawn_interval = 0.7
			wave_length = 25
		14, 15, 16, 17:
			enemy_table.add_item(4, 15) # purple non dash
			enemy_count = 27
			spawn_interval = 0.6
			
		18, 19, 20:
			enemy_count = 30
			spawn_interval = 0.5
		_:
			enemy_count += 2
			wave_length += 1.0
			#spawn_interval = max(0.4, spawn_interval - 0.05)

func show_next_wave_text():
	SoundManager.play_warHorn()
	next_wave_label.visible = true
	var tween = create_tween()
	tween.tween_property(next_wave_label, "modulate:a", 1.0, 0.5).from(0.0)
	tween.parallel().tween_property(next_wave_label, "position:y", 120, 1.0).from(-get_viewport().size.y)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(5.0)
	tween.tween_property(next_wave_label, "modulate:a", 0.0, 1.0).from(1.0)
	await get_tree().create_timer(7.0).timeout
	next_wave_label.visible = false


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

#region get_spawn_position()
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
#endregion
