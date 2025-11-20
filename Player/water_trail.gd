extends Line2D

@export var max_points: int = 50
@export var min_spawn_distance: float = 10.0

@onready var parent = get_parent()
var last_spawn_pos: Vector2 = Vector2.ZERO

#func _process(_delta):
	#var pos = parent.global_position
	#add_point(pos)
	#
	#if get_point_count() > max_points:
		#remove_point(0)

func _ready() -> void:
	set_as_top_level(true) 
	clear_points()
	if parent:
		last_spawn_pos = parent.global_position

func _process(_delta):
	if not parent:
		return
		
	var current_pos = parent.global_position
	
	if current_pos.distance_to(last_spawn_pos) > min_spawn_distance:
		add_point(current_pos)
		last_spawn_pos = current_pos
		
		if get_point_count() > max_points:
			remove_point(0)
