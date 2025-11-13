extends Node

const CHUNK_SIZE = 8000
# Distance to use to load next chunk ahead of time.
const VIEW_SIZE = CHUNK_SIZE / 2

var player: Node2D = null
# Current Chunk is the chunk the player is in.
# X-Y Coordinates of Current Chunk. 
var current_chunk_start_position: Vector2 = Vector2(0, 0)
# Current chunk key X and Y are used to access the chunks_map. Use with create_key
var current_chunk_key_x = 0
var current_chunk_key_y = 0

# List of Map Segments to generate chunks. All island designs.
const MAP_SEGMENTS = [
	preload("res://Game_Objects/Islands/island_0.tscn"),
	preload("res://Game_Objects/Islands/island_1.tscn")
]

# Map to keep track of loaded scenes. Will be reused when player re-enters already explored position.
var chunks_map = {
	"0.0_0.0": "orignal_scene_no_file"
}

@onready var parent_scene = $scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		# ---- +X Axis -----
		var player_position: Vector2 = player.global_position
		var distance_from_chunk: Vector2 = player_position - current_chunk_start_position
		
		if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			var vector_change = Vector2(1,0)
			update_map_by_player_position(vector_change)
		
		# Move current chunk position to new chunk after player has
		if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			var vector_change = Vector2(1,0)
			update_current_chunk(vector_change)
		
		# ---- -X Axis -----
		if distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			var vector_change = Vector2(-1,0)
			update_map_by_player_position(vector_change)
		
		# Move current chunk position to new chunk after player has
		if distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			var vector_change = Vector2(-1,0)
			update_current_chunk(vector_change)
		
		# ---- +Y Axis -----
		if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			var vector_change = Vector2(0,1)
			update_map_by_player_position(vector_change)
		
		# Move current chunk position to new chunk after player has
		if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			var vector_change = Vector2(0,1)
			update_current_chunk(vector_change)
		
		# ---- -Y Axis -----
		if distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			var vector_change = Vector2(0,-1)
			update_map_by_player_position(vector_change)
		
		# Move current chunk position to new chunk after player has
		if distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			var vector_change = Vector2(0,-1)
			update_current_chunk(vector_change)
			
		# TODO Deload any necessary chunksnstantiate()
	
func load_chunk(x, y): 
	var scene = MAP_SEGMENTS[1].instantiate()
	scene.position = Vector2(x, y)
	parent_scene.add_child.call_deferred(scene)
	
func create_key(x, y): 
	return str(x) + "_" + str(y)
	
func update_map_by_player_position(vector_change: Vector2):
	var next_x = current_chunk_key_x + vector_change.x
	var next_y = current_chunk_key_y + vector_change.y
	
	var key = create_key(next_x, next_y)
	
	if not chunks_map.has(key):
		load_chunk(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
		chunks_map[key] = MAP_SEGMENTS[1]
		
func update_current_chunk(vector_change: Vector2):
	var next_x = current_chunk_key_x + vector_change.x
	var next_y = current_chunk_key_y + vector_change.y
	
	current_chunk_start_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
	current_chunk_key_x = next_x
	current_chunk_key_y = next_y
	
func connect_to_parent(shift):
	var next_segment = get_random_segement(shift)
	
	get_parent().add_child.call_deferred(next_segment)

func rotate_segement(segment: Node2D): 
	var random_rotation = (randi() % 4) * PI / 2 # 0, PI/2, PI, 3*PI/2 radians
	segment.rotate(random_rotation)

func get_random_segement(shift):
	var segment = MAP_SEGMENTS[randi() % len(MAP_SEGMENTS) - 1]
	
	var instance = segment.instantiate()
	if shift == 0:
		instance.position = Vector2(8000, 0)
	elif shift == 1:
		instance.position = Vector2(10, -19)
	elif shift == 2:
		instance.position = Vector2(-10, 19)
	else: 
		instance.position = Vector2(-10, -19)
	
	return instance
