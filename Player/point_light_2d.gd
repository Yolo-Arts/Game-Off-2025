extends PointLight2D



@onready var parent = get_parent()


#func _process(_delta):
	#var pos = parent.global_position
	#add_point(pos)
	#
	#if get_point_count() > max_points:
		#remove_point(0)

func _ready() -> void:
	set_as_top_level(true) 

func _process(_delta):
	if not parent:
		return
		
	position = parent.global_position
