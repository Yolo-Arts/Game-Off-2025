extends Node

const SPAWN_RADIUS = 900
var swapper_index = 0

@export var basic_enemy_scene: PackedScene
@export var dash_enemy_scene: PackedScene
@export var projectile_enemy_scene: PackedScene
@export var boss_enemy_scene: PackedScene

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
@onready var star_6: TextureRect = %Star6
@onready var star_7: TextureRect = %Star7

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
	print("--- Starting Wave ", difficulty, " ---")
	
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
	if enemy_stats.is_boss:
		print("Boss enemy spawning")
		enemy_scene = boss_enemy_scene
	elif enemy_stats.can_dash:
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
		
		#region black boats
		0:
			setup_bounty_wave(star_1)
			enemy_count = 5 # default 5
			spawn_interval = 3
			wave_length = 20 # default 20
		1:
			enemy_table.remove_item(0)
			enemy_table.add_item(1, 15)
			enemy_count = 7
			spawn_interval = 2
			wave_length = 20
		2:
			enemy_table.remove_item(1)
			enemy_table.add_item(2, 15) 
			enemy_count = 15
			spawn_interval = 2.0
			wave_length = 30
			
		3, 4:
			enemy_count = 15
			spawn_interval = 1.8
			wave_length = 20
		#endregion
		
		#region red boats
		5:
			setup_bounty_wave(star_2)
			enemy_table.remove_item(2)
			enemy_table.add_item(3, 15) # Add red boat
			enemy_count = 10
			spawn_interval = 2
			wave_length = 20
		6:
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		7:
			enemy_table.remove_item(3)
			enemy_table.add_item(4, 15)
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		8:
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		9:
			enemy_table.remove_item(4)
			enemy_table.add_item(5, 15)
			enemy_count = 10
			spawn_interval = 1.0
			wave_length = 15
		#endregion
		
		#region Green Boat
		10:
			setup_bounty_wave(star_3)
			enemy_table.add_item(6, 15) # Add red boat
			enemy_count = 5
			spawn_interval = 2
			wave_length = 15
		11:
			enemy_table.remove_item(5)
			enemy_count = 5
			spawn_interval = 1.7
			wave_length = 15
		12:
			enemy_table.remove_item(6)
			enemy_table.add_item(7, 15)
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		13:
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		14:
			enemy_table.remove_item(7)
			enemy_table.add_item(8, 15)
			enemy_count = 10
			spawn_interval = 1.0
			wave_length = 15
		#endregion
		
		#region Purple (Dash) Boat
		15:
			setup_bounty_wave(star_4)
			enemy_table.add_item(9, 15) # Purple
			enemy_count = 7
			spawn_interval = 2
			wave_length = 15
		16:
			enemy_table.remove_item(8)
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		17:
			enemy_table.remove_item(9)
			enemy_table.add_item(10, 15)
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		18:
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		19:
			enemy_table.remove_item(10)
			enemy_table.add_item(11, 15)
			enemy_count = 10
			spawn_interval = 1.0
			wave_length = 15
		#endregion
		
		#region Orange (Projectile) Boat
		20:
			setup_bounty_wave(star_5)
			enemy_table.remove_item(11)
			enemy_table.add_item(12, 15) # Orange
			enemy_count = 7
			spawn_interval = 2
			wave_length = 15
		21:
			enemy_count = 5
			spawn_interval = 1.7
			wave_length = 15
		22:
			enemy_table.remove_item(12)
			enemy_table.add_item(13, 15)
			enemy_count = 7
			spawn_interval = 1.7
			wave_length = 15
		23:
			enemy_table.remove_item(13)
			enemy_table.add_item(14, 15)
			enemy_count = 10
			spawn_interval = 1.0
			wave_length = 15
		#endregion
		24:
			setup_bounty_wave(star_6) 
			enemy_table.remove_item(14)
			enemy_table.add_item(33, 1000000) # dreadnought
			enemy_count = 1
			wave_length = 30
		25:
			setup_bounty_wave(star_7)
			#enemy_table.remove_item(14)
			enemy_table.remove_item(33)
			enemy_table.add_item(15, 15) # Black4
			enemy_table.add_item(16, 15) # Red4
			enemy_table.add_item(17, 15) # Green4
			enemy_table.add_item(11, 15) # Purple
			wave_length = 60
			enemy_count = 60
			spawn_interval = 1.0
		26, 27:
			pass
		28:
			enemy_table.remove_item(15) 
			enemy_table.remove_item(16) 
			enemy_table.remove_item(17) 
			enemy_table.add_item(18, 15) # Black5
			enemy_table.add_item(19, 15) # Red5
			enemy_table.add_item(20, 15) # Green5
		29:
			pass
		30:
			enemy_table.remove_item(18) 
			enemy_table.remove_item(19) 
			enemy_table.remove_item(20) 
			enemy_table.add_item(21, 15) # Black6
			enemy_table.add_item(22, 15) # Red6
			enemy_table.add_item(23, 15) # Green6
		31, 32: 
			pass
		33:
			enemy_table.remove_item(21) 
			enemy_table.remove_item(22) 
			enemy_table.remove_item(23) 
			enemy_table.add_item(24, 15) # Black7
			enemy_table.add_item(25, 15) # Red7
			enemy_table.add_item(26, 15) # Green7
		34: pass
		35:
			enemy_table.remove_item(24) 
			enemy_table.remove_item(25) 
			enemy_table.remove_item(26) 
			enemy_table.add_item(27, 15) # Black8
			enemy_table.add_item(28, 15) # Red8
			enemy_table.add_item(29, 15) # Green8
		36: pass
		37:
			enemy_table.remove_item(27) 
			enemy_table.remove_item(28) 
			enemy_table.remove_item(29) 
			enemy_table.add_item(30, 15) # Black9
			enemy_table.add_item(31, 15) # Red9
			enemy_table.add_item(32, 15) # Green9
			enemy_table.add_item(33, 5)
		_:
			enemy_count += 4
			wave_length += 2.0
			spawn_interval -= 0.05

func setup_bounty_wave(star_node: Control):
	star_node.visible = true
	Globals.update_score("BOUNTY_POINT")
	show_next_wave_text()

func show_next_wave_text():
	SoundManager.play_warHorn()
	next_wave_label.visible = true
	
	var current_text = "Next Wave Incoming.\n"
	if difficulty == 24:
		next_wave_label.text = "Boss Arrived.\nKill the boss!"
	
	elif difficulty < 24:
		var waves_remaining = 24 - difficulty
		next_wave_label.text = "Next Wave Incoming.\nBoss arriving in %d waves.\nDifficulty Increased!" % waves_remaining
		
	else:
		next_wave_label.text = "Next Wave Incoming.\nDifficulty Increased!"
	
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
	
	if difficulty > 37 && difficulty % 2 == 0:
		Globals.health_mult *= 2
	
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
