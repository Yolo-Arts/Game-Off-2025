extends Node

@export var check_interval: float = 0.2
@export var cull_distance: float = 2000.0 
@export var timeout_duration: float = 10.0  

var _check_timer: float = 0.0
var _is_active: bool = true
var parent
var player 
var time_outside_range: float = 0.0  

func _ready():
	parent = get_parent()
	player = get_tree().get_first_node_in_group("player")

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
		
		#for child in parent.find_children("*", "CollisionShape2D"):
			#child.disabled = not _is_active
	
	if is_in_range:
		time_outside_range = 0.0
	else:
		time_outside_range += check_interval
		
		if time_outside_range >= timeout_duration:
			print("Queue free out of range enemy for too long")
			parent.queue_free()
