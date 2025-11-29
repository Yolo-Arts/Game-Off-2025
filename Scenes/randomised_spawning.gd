extends Node

var player_instance: Iso_player

func _ready():
	teleport_existing_player.call_deferred()


func teleport_existing_player():
	player_instance = get_tree().get_first_node_in_group("player")
	
	if not player_instance:
		print("Player node not found")
		return
	
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	
	if spawn_points.is_empty():
		print("The island might not be loaded.")
		teleport_existing_player.call_deferred()
		return
		
	var random_index = randi() % spawn_points.size()
	var random_spawn_point = spawn_points[random_index]
	
	player_instance.global_position = random_spawn_point.global_position
	print("Player teleported to random spawn point at: ", player_instance.global_position)
