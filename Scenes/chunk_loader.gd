extends Node

const CHUNK_SIZE: int = 16000
# Distance to use to load next chunk ahead of time.
const VIEW_SIZE: int = CHUNK_SIZE / 2

var player: Node2D = null
# Current Chunk is the chunk the player is in.
# X-Y Coordinates of Current Chunk. 
var current_chunk_start_position: Vector2 = Vector2(0, 0)
# Current chunk key X and Y are used to access the chunks_map. Use with create_key
var current_chunk_key_x: int = 0
var current_chunk_key_y: int = 0

class IslandClusters:
	var scene_ref: Node
	var coordinate: Vector2
	var map_segement_file: Resource

# List of Map Segments to generate chunks. All island designs.
const MAP_SEGMENTS: Array[Resource] = [
	preload("res://Game_Objects/Islands/island_1_no_clouds.tscn")
]

# Map to keep track of loaded scenes. Will be reused when player re-enters already explored position.
var chunks_map: Dictionary[String, IslandClusters] = {}
var queue_chunks: Array[String] = []
var MAX_CHUNKS_LOADED: int = 4

@onready var parent_scene = $scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	#current_chunk_start_position = player.global_position
	update_map_by_player_position(Vector2(current_chunk_key_x,current_chunk_key_y))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		var player_position: Vector2 = player.global_position
		var distance_from_chunk: Vector2 = player_position - current_chunk_start_position
		
		# ---- +X Axis -----
		if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			var vector_change = Vector2(1,0)
			update_map_by_player_position(vector_change)
		# ---- -X Axis -----
		elif distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			var vector_change = Vector2(-1,0)
			update_map_by_player_position(vector_change)
		
		# ---- +Y Axis -----
		if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			var vector_change = Vector2(0,1)
			update_map_by_player_position(vector_change)
		# ---- -Y Axis -----
		elif distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			var vector_change = Vector2(0,-1)
			update_map_by_player_position(vector_change)
		
		# Move current chunk position to new chunk after player has
		if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			var vector_change = Vector2(1,0)
			update_current_chunk(vector_change)
		elif distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			var vector_change = Vector2(-1,0)
			update_current_chunk(vector_change)
		
		if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			var vector_change = Vector2(0,1)
			update_current_chunk(vector_change)
		elif distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			var vector_change = Vector2(0,-1)
			update_current_chunk(vector_change)
		
func load_chunk(x, y): 
	var scene: Node = MAP_SEGMENTS[0].instantiate()
	scene.position = Vector2(x, y)
	parent_scene.add_child.call_deferred(scene)
	return scene
	
func create_key(x, y): 
	return str(x) + "_" + str(y)
	
func update_map_by_player_position(vector_change: Vector2):
	var next_x = current_chunk_key_x + vector_change.x
	var next_y = current_chunk_key_y + vector_change.y
	
	var key = create_key(next_x, next_y)
	
	if not chunks_map.has(key):
		var next_chunk_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
		var scene: Node = load_chunk(next_chunk_position.x, next_chunk_position.y)
		
		# Save for next time
		var island_cluster: IslandClusters = IslandClusters.new()
		island_cluster.scene_ref = scene
		island_cluster.coordinate = next_chunk_position
		island_cluster.map_segement_file = MAP_SEGMENTS[0]
		chunks_map[key] = island_cluster
		queue_chunks.append(key)
	elif chunks_map.has(key) && key not in queue_chunks: 
		var island_cluster: IslandClusters = chunks_map[key]
		load_chunk(island_cluster.coordinate.x, island_cluster.coordinate.y)
		queue_chunks.append(key)
		
func update_current_chunk(vector_change: Vector2):
	var next_x = current_chunk_key_x + vector_change.x
	var next_y = current_chunk_key_y + vector_change.y
	
	current_chunk_start_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
	current_chunk_key_x = next_x
	current_chunk_key_y = next_y
	
	check_queue()
	
	
func check_queue():
	if queue_chunks.size() > MAX_CHUNKS_LOADED: 
		# Remove first
		var to_remove_index = queue_chunks.pop_front()
		var to_remove = chunks_map[to_remove_index]
		to_remove.scene_ref.queue_free()
	
