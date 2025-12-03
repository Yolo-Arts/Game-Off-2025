extends Node

@export var check_interval: float = 0.2
@export var cull_distance: float = 2000.0
@export var timeout_duration: float = 10.0

const TELEPORT_RADIUS: float = 800.0 

var _check_timer: float = 0.0
var _is_active: bool = true
var parent: Node2D 
var player: Node2D 
var time_outside_range: float = 0.0

func _ready():
	parent = get_parent() as Node2D
	player = get_tree().get_first_node_in_group("player") as Node2D

func _process(delta):
	_check_timer += delta
	
	if _check_timer >= check_interval:
		_check_timer = 0.0
		_check_visibility()

func _check_visibility():
	var is_in_range = true
	if player:
		var distance_to_player = parent.global_position.distance_to(player.global_position)
		is_in_range = distance_to_player < cull_distance
	
	var should_be_active = is_in_range
	
	if should_be_active != _is_active:
		_is_active = should_be_active
		parent.set_process(_is_active)
		parent.set_physics_process(_is_active)
		parent.visible = _is_active
		
	
	if is_in_range:
		time_outside_range = 0.0
	else:
		time_outside_range += check_interval
		
		if time_outside_range >= timeout_duration:
			print("Dreadnought out of range for too long. Teleporting.")
			
			_teleport_near_player()
			
			time_outside_range = 0.0
			
func _teleport_near_player():
	if !player or !parent:
		return
		
	var new_position = _get_safe_teleport_position()
	parent.global_position = new_position
	_is_active = true
	parent.set_process(true)
	parent.set_physics_process(true)
	parent.visible = true


func _get_safe_teleport_position() -> Vector2:
	var spawn_position = Vector2.ZERO
	var player_pos = player.global_position
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in range(4):
		
		spawn_position = player_pos + (random_direction * TELEPORT_RADIUS)
		var additional_check_offset = random_direction * 20
		var query_paramaters = PhysicsRayQueryParameters2D.create(
			player_pos, 
			spawn_position + additional_check_offset, 
			1 << 3
		)
		
		var space_state = get_tree().root.world_2d.direct_space_state
		var result = space_state.intersect_ray(query_paramaters)
		if result.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position
