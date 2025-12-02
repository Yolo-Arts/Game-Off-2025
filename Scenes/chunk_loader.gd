#region Old Chunk Loader
#extends Node
#
#const CHUNK_SIZE: int = 16000
## Distance to use to load next chunk ahead of time.
#const VIEW_SIZE: int = CHUNK_SIZE / 2
#
#var player: Node2D = null
## Current Chunk is the chunk the player is in.
## X-Y Coordinates of Current Chunk. 
#var current_chunk_start_position: Vector2 = Vector2(0, 0)
## Current chunk key X and Y are used to access the chunks_map. Use with create_key
#var current_chunk_key_x: int = 0
#var current_chunk_key_y: int = 0
#
#class IslandClusters:
	#var scene_ref: Node
	#var coordinate: Vector2
	#var map_segement_file: Resource
#
## List of Map Segments to generate chunks. All island designs.
#const MAP_SEGMENTS: Array[Resource] = [
	##preload("res://Game_Objects/Islands/island_1_no_seabed.tscn")
	#
	##preload("res://Game_Objects/Islands/island_1_no_clouds.tscn"),
	#preload("res://Game_Objects/Islands/island_2_no_clouds.tscn")
	##preload("res://Scenes/island_1.tscn")
	#
#]
#
## Map to keep track of loaded scenes. Will be reused when player re-enters already explored position.
#var chunks_map: Dictionary[String, IslandClusters] = {}
#var queue_chunks: Array[String] = []
#var MAX_CHUNKS_LOADED: int = 6
#
#var loading_in_progress: Array[String] = []
#
#@onready var parent_scene = $scene
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player") as Node2D
	##current_chunk_start_position = player.global_position
	#update_map_by_player_position(Vector2(current_chunk_key_x,current_chunk_key_y))
	#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if player:
		#var player_position: Vector2 = player.global_position
		#var distance_from_chunk: Vector2 = player_position - current_chunk_start_position
		#
		## ---- +X Axis -----
		#if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			#var vector_change = Vector2(1,0)
			#update_map_by_player_position(vector_change)
		## ---- -X Axis -----
		#elif distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > VIEW_SIZE / 2:
			#var vector_change = Vector2(-1,0)
			#update_map_by_player_position(vector_change)
		#
		## ---- +Y Axis -----
		#if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			#var vector_change = Vector2(0,1)
			#update_map_by_player_position(vector_change)
		## ---- -Y Axis -----
		#elif distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > VIEW_SIZE / 2:
			#var vector_change = Vector2(0,-1)
			#update_map_by_player_position(vector_change)
		#
		## Move current chunk position to new chunk after player has
		#if distance_from_chunk.x > 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			#var vector_change = Vector2(1,0)
			#update_current_chunk(vector_change)
		#elif distance_from_chunk.x < 0 && abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
			#var vector_change = Vector2(-1,0)
			#update_current_chunk(vector_change)
		#
		#if distance_from_chunk.y > 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			#var vector_change = Vector2(0,1)
			#update_current_chunk(vector_change)
		#elif distance_from_chunk.y < 0 && abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
			#var vector_change = Vector2(0,-1)
			#update_current_chunk(vector_change)
		#
#func load_chunk(scene_resource: Resource, x, y): 
	#var scene: Node = scene_resource.instantiate()
	#scene.position = Vector2(x, y)
	#parent_scene.add_child.call_deferred(scene)
	#return scene
	#
#func create_key(x, y): 
	#return str(x) + "_" + str(y)
	#
#func update_map_by_player_position(vector_change: Vector2):
	#var next_x = current_chunk_key_x + vector_change.x
	#var next_y = current_chunk_key_y + vector_change.y
	#
	#var key = create_key(next_x, next_y)
	#
	#if not chunks_map.has(key):
		#var next_chunk_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
		#
		#var random_index = randi() % MAP_SEGMENTS.size()
		#var chosen_map_segment = MAP_SEGMENTS[random_index]
		#var scene: Node = load_chunk(chosen_map_segment, next_chunk_position.x, next_chunk_position.y)
		#
		## Save for next time
		#var island_cluster: IslandClusters = IslandClusters.new()
		#island_cluster.scene_ref = scene
		#island_cluster.coordinate = next_chunk_position
		#island_cluster.map_segement_file = MAP_SEGMENTS[0]
		#chunks_map[key] = island_cluster
		#queue_chunks.append(key)
	#elif chunks_map.has(key) && key not in queue_chunks: 
		#var island_cluster: IslandClusters = chunks_map[key]
		#parent_scene.add_child.call_deferred(island_cluster.scene_ref)
		##load_chunk(island_cluster.coordinate.x, island_cluster.coordinate.y)
		#queue_chunks.append(key)
		#
#func update_current_chunk(vector_change: Vector2):
	#var next_x = current_chunk_key_x + vector_change.x
	#var next_y = current_chunk_key_y + vector_change.y
	#
	#current_chunk_start_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
	#current_chunk_key_x = next_x
	#current_chunk_key_y = next_y
	#
	#check_queue()
	#
	#
#func check_queue():
	#if queue_chunks.size() > MAX_CHUNKS_LOADED: 
		## Remove first
		#var to_remove_index = queue_chunks.pop_front()
		#var to_remove = chunks_map[to_remove_index]
		#to_remove.scene_ref.queue_free()
	#
#endregion

#region New Code Region
#extends Node
#
#const CHUNK_SIZE: int = 16000
#const VIEW_SIZE: int = CHUNK_SIZE / 2
#var MAX_CHUNKS_LOADED: int = 6
#
#var player: Node2D = null
#var current_chunk_start_position: Vector2 = Vector2(0, 0)
#var current_chunk_key_x: int = 0
#var current_chunk_key_y: int = 0
#
#var chunks_map: Dictionary[String, IslandClusters] = {}
#var queue_chunks: Array[String] = []
#
#class IslandClusters:
	#var scene_ref: Node
	#var coordinate: Vector2
	#var map_segement_file: Resource
#
## Preloaded resources (Keep this as is)
#const MAP_SEGMENTS: Array[Resource] = [
	##preload("res://Game_Objects/Islands/island_2_no_clouds.tscn")
	#preload("res://Game_Objects/Islands/island_2_less_hitboxes.tscn")
#]
#
#
## To prevent trying to load the same chunk twice while the thread is running
#var loading_in_progress: Array[String] = []
#
#@onready var parent_scene = $scene
#
#func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player") as Node2D
	## Initial load doesn't need threads as it happens behind a loading screen usually
	#update_map_by_player_position(Vector2(0,0))
#
#func _process(delta: float) -> void:
	#if not player: return
	#
	#var player_position: Vector2 = player.global_position
	#var distance_from_chunk: Vector2 = player_position - current_chunk_start_position
	#
	## Check X Axis
	#if abs(distance_from_chunk.x) > VIEW_SIZE / 2:
		#var dir = 1 if distance_from_chunk.x > 0 else -1
		#update_map_by_player_position(Vector2(dir, 0))
#
	## Check Y Axis
	#if abs(distance_from_chunk.y) > VIEW_SIZE / 2:
		#var dir = 1 if distance_from_chunk.y > 0 else -1
		#update_map_by_player_position(Vector2(0, dir))
		#
	## Update Current Chunk Center
	#if abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
		#var dir = 1 if distance_from_chunk.x > 0 else -1
		#update_current_chunk(Vector2(dir, 0))
		#
	#if abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
		#var dir = 1 if distance_from_chunk.y > 0 else -1
		#update_current_chunk(Vector2(0, dir))
#
## ---------------------------------------------------------
## OPTIMIZATION 1: Threaded Instantiation
## ---------------------------------------------------------
#
#func update_map_by_player_position(vector_change: Vector2):
	#var next_x = current_chunk_key_x + vector_change.x
	#var next_y = current_chunk_key_y + vector_change.y
	#var key = create_key(next_x, next_y)
	#
	## If we are already loading this key in a background thread, stop.
	#if key in loading_in_progress:
		#return
#
	#if not chunks_map.has(key):
		## Mark as loading so we don't trigger it again next frame
		#loading_in_progress.append(key)
		#
		#var next_chunk_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
		#var random_index = randi() % MAP_SEGMENTS.size()
		#var chosen_map_segment = MAP_SEGMENTS[random_index]
		#
		## Run the instantiation on a background thread
		#WorkerThreadPool.add_task(
			#_thread_instantiate_chunk.bind(chosen_map_segment, next_chunk_position, key)
		#)
#
	#elif chunks_map.has(key) && key not in queue_chunks:
		## OPTIMIZATION 2: Re-add existing child instead of loading new
		#var island_cluster: IslandClusters = chunks_map[key]
		#
		## Check if the node is valid before adding
		#if is_instance_valid(island_cluster.scene_ref):
			#if island_cluster.scene_ref.get_parent() == null:
				#parent_scene.add_child(island_cluster.scene_ref)
			#queue_chunks.append(key)
		#else:
			## If for some reason it was deleted, clear entry and reload
			#chunks_map.erase(key)
			#update_map_by_player_position(vector_change)
#
## This runs on a separate thread. DO NOT touch the SceneTree here.
#func _thread_instantiate_chunk(resource: Resource, position: Vector2, key: String):
	## This is the heavy operation that causes lag
	#var new_scene = resource.instantiate()
	#new_scene.position = position
	#
	## Pass the created node back to the main thread
	#call_deferred("_finish_loading_chunk", new_scene, position, key, resource)
#
## This runs on the Main Thread again
#func _finish_loading_chunk(scene: Node, position: Vector2, key: String, resource: Resource):
	#loading_in_progress.erase(key)
	#
	## Add to scene tree
	#parent_scene.add_child(scene)
	#
	## Save data
	#var island_cluster: IslandClusters = IslandClusters.new()
	#island_cluster.scene_ref = scene
	#island_cluster.coordinate = position
	#island_cluster.map_segement_file = resource
	#
	#chunks_map[key] = island_cluster
	#queue_chunks.append(key)
#
## ---------------------------------------------------------
## OPTIMIZATION 2: Pooling (Remove instead of Free)
## ---------------------------------------------------------
#
#func check_queue():
	#if queue_chunks.size() > MAX_CHUNKS_LOADED:
		#var to_remove_index = queue_chunks.pop_front()
		#
		#if chunks_map.has(to_remove_index):
			#var to_remove = chunks_map[to_remove_index]
			#
			## Remove from tree, but KEEP in memory (chunks_map)
			#if is_instance_valid(to_remove.scene_ref):
				#parent_scene.remove_child(to_remove.scene_ref)
			#
			## OPTIONAL: If memory usage is too high, you can actually queue_free 
			## chunks that are VERY far away (e.g., > 20 chunks away), 
			## but for immediate neighbors, just remove_child.
#
#func create_key(x, y):
	#return str(x) + "_" + str(y)
#
#func update_current_chunk(vector_change: Vector2):
	#current_chunk_key_x += vector_change.x
	#current_chunk_key_y += vector_change.y
	#current_chunk_start_position = Vector2(CHUNK_SIZE * current_chunk_key_x, CHUNK_SIZE * current_chunk_key_y)
	#check_queue()
#endregion

#region New Code Region
extends Node

# --- CONFIGURATION ---
const CHUNK_SIZE: int = 16000
const VIEW_SIZE: int = CHUNK_SIZE / 2
const MAX_CHUNKS_LOADED: int = 6

# *** IMPORTANT: Make sure this matches the name in your Scene Tree exactly ***
const BASE_NODE_NAME: String = "base2" 

# --- DATA STRUCTURES ---
class IslandClusters:
	var scene_ref: Node
	var coordinate: Vector2
	var map_segement_file: Resource

# --- STATE VARIABLES ---
var player: Node2D = null
var current_chunk_start_position: Vector2 = Vector2(0, 0)
var current_chunk_key_x: int = 0
var current_chunk_key_y: int = 0

var chunks_map: Dictionary[String, IslandClusters] = {}
var queue_chunks: Array[String] = []

# --- OPTIMIZATION VARIABLES ---
var loading_in_progress: Array[String] = []
var layers_to_add_queue: Array[Dictionary] = [] 

@onready var parent_scene = $scene

# --- RESOURCES ---
const MAP_SEGMENTS: Array[Resource] = [
	# Point this to your island scene file
	preload("res://Game_Objects/Islands/island_2_less_hitboxes.tscn") 
]

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	update_map_by_player_position(Vector2(0,0))

const ADD_LAYERS_EVERY_N_FRAMES = 3
var frame_counter = 0

func _process(delta: float) -> void:
	frame_counter += 1
	# 1. PROCESS THE QUEUE (The Shredder)
	# Add one visual layer back per frame
	if not layers_to_add_queue.is_empty() and frame_counter >= ADD_LAYERS_EVERY_N_FRAMES:
		var job = layers_to_add_queue.pop_front()
		var parent_node = job["parent"]
		var child_node = job["child"]
		
		if is_instance_valid(parent_node) and is_instance_valid(child_node):
			parent_node.add_child(child_node)
		frame_counter = 0
	
	# 2. PLAYER LOGIC
	if player:
		_handle_player_movement()

func _handle_player_movement():
	var player_position: Vector2 = player.global_position
	var distance_from_chunk: Vector2 = player_position - current_chunk_start_position
	
	# Check X Axis
	if abs(distance_from_chunk.x) > VIEW_SIZE / 2:
		var dir = 1 if distance_from_chunk.x > 0 else -1
		update_map_by_player_position(Vector2(dir, 0))

	# Check Y Axis
	if abs(distance_from_chunk.y) > VIEW_SIZE / 2:
		var dir = 1 if distance_from_chunk.y > 0 else -1
		update_map_by_player_position(Vector2(0, dir))
		
	# Update Current Chunk Center
	if abs(distance_from_chunk.x) > CHUNK_SIZE / 2:
		var dir = 1 if distance_from_chunk.x > 0 else -1
		update_current_chunk(Vector2(dir, 0))
		
	if abs(distance_from_chunk.y) > CHUNK_SIZE / 2:
		var dir = 1 if distance_from_chunk.y > 0 else -1
		update_current_chunk(Vector2(0, dir))

# --- CORE LOGIC ---

func update_map_by_player_position(vector_change: Vector2):
	var next_x = current_chunk_key_x + vector_change.x
	var next_y = current_chunk_key_y + vector_change.y
	var key = create_key(next_x, next_y)
	
	if key in loading_in_progress:
		return

	if not chunks_map.has(key):
		# Load New Chunk via Thread
		loading_in_progress.append(key)
		var next_chunk_position = Vector2(CHUNK_SIZE * next_x, CHUNK_SIZE * next_y)
		var random_index = randi() % MAP_SEGMENTS.size()
		var chosen_map_segment = MAP_SEGMENTS[random_index]
		
		WorkerThreadPool.add_task(
			_thread_instantiate_chunk.bind(chosen_map_segment, next_chunk_position, key)
		)

	elif chunks_map.has(key) && key not in queue_chunks:
		# Load Existing Chunk (Instant Re-add)
		var island_cluster: IslandClusters = chunks_map[key]
		if is_instance_valid(island_cluster.scene_ref):
			if island_cluster.scene_ref.get_parent() == null:
				parent_scene.add_child(island_cluster.scene_ref)
			queue_chunks.append(key)
		else:
			chunks_map.erase(key)
			update_map_by_player_position(vector_change)

# --- THREADING FUNCTIONS ---

# RUNS ON BACKGROUND THREAD
# RUNS ON BACKGROUND THREAD
#func _thread_instantiate_chunk(resource: Resource, position: Vector2, key: String):
	#var new_scene = resource.instantiate()
	#new_scene.position = position
	#
	## --- THE SHREDDER LOGIC ---
	#var heavy_layers = []
	#var children = new_scene.get_children()
	#
	#
	#for child in children:
		## 1. KEEP BASE (Physics)
		#if child.name == BASE_NODE_NAME:
			#continue
		#
		## 2. KEEP SPAWN POINTS (Logic)
		## We must keep this attached so the Spawn Script can find it immediately
		#if child.name == "SpawnPoints":
			#continue
		#
		#if child.name == "Seabed" or child.name == "underwater3": 
			#print("Kept seabed")
			#continue
		#
		## 3. DETACH EVERYTHING ELSE (Visuals)
		## Water, Trees, etc. get removed and added back slowly
		#new_scene.remove_child(child)
		#heavy_layers.append(child)
	#
	#
	## Send back to Main Thread
	#call_deferred("_finish_loading_chunk", new_scene, heavy_layers, position, key, resource)
#
## RUNS ON MAIN THREAD
#func _finish_loading_chunk(scene: Node, heavy_layers: Array, position: Vector2, key: String, resource: Resource):
	#loading_in_progress.erase(key)
	#
	## 1. Add the Scene (which now ONLY contains base2)
	#parent_scene.add_child(scene)
	#
	## 2. Queue the rest to load 1 per frame
	#for layer in heavy_layers:
		#layers_to_add_queue.append({
			#"parent": scene,
			#"child": layer
		#})
	#
	## 3. Store Data
	#var island_cluster: IslandClusters = IslandClusters.new()
	#island_cluster.scene_ref = scene
	#island_cluster.coordinate = position
	#island_cluster.map_segement_file = resource
	#chunks_map[key] = island_cluster
	#queue_chunks.append(key)

# --- THREADING FUNCTIONS (CORRECTED) ---

# RUNS ON BACKGROUND THREAD
# This function's ONLY job is to instantiate the scene. It MUST NOT touch the scene tree.
func _thread_instantiate_chunk(resource: Resource, position: Vector2, key: String):
	# Instantiate the scene on the background thread. This is safe.
	var new_scene = resource.instantiate()
	
	# IMPORTANT: We set the position here, which is safe.
	# We DO NOT touch its children here.
	new_scene.position = position
	
	# Send the fully instantiated scene back to the Main Thread for processing.
	call_deferred("_finish_loading_chunk", new_scene, position, key, resource)

# RUNS ON MAIN THREAD
# All scene tree manipulation happens here.
func _finish_loading_chunk(scene: Node, position: Vector2, key: String, resource: Resource):
	loading_in_progress.erase(key)
	
	# --- THE SHREDDER LOGIC (NOW ON MAIN THREAD) ---
	var heavy_layers = []
	# Make a copy of the children array to iterate over, as we are modifying the original.
	var children = scene.get_children().duplicate()
	
	for child in children:
		# 1. KEEP BASE (Physics)
		if child.name == BASE_NODE_NAME:
			continue
		
		# 2. KEEP SPAWN POINTS (Logic)
		if child.name == "SpawnPoints":
			continue
			
		# 3. KEEP SEABED AND UNDERWATER3
		if child.name == "Seabed" or child.name == "underwater3":
			# The print statement was good for debugging, but we can remove it now.
			# print("Kept seabed/underwater3: ", child.name)
			continue
		
		# 4. DETACH EVERYTHING ELSE (Visuals)
		# Water, Trees, etc. get removed and added back slowly
		scene.remove_child(child)
		heavy_layers.append(child)
	
	# 1. Add the Scene (which now contains base2, SpawnPoints, Seabed, and underwater3)
	parent_scene.add_child(scene)
	
	# 2. Queue the rest to load 1 per frame
	for layer in heavy_layers:
		layers_to_add_queue.append({
			"parent": scene,
			"child": layer
		})
	
	# 3. Store Data
	var island_cluster: IslandClusters = IslandClusters.new()
	island_cluster.scene_ref = scene
	island_cluster.coordinate = position
	island_cluster.map_segement_file = resource
	chunks_map[key] = island_cluster
	queue_chunks.append(key)


# --- CLEANUP LOGIC ---

func check_queue():
	if queue_chunks.size() > MAX_CHUNKS_LOADED:
		var to_remove_index = queue_chunks.pop_front()
		if chunks_map.has(to_remove_index):
			var to_remove = chunks_map[to_remove_index]
			if is_instance_valid(to_remove.scene_ref):
				parent_scene.remove_child(to_remove.scene_ref)

func update_current_chunk(vector_change: Vector2):
	current_chunk_key_x += vector_change.x
	current_chunk_key_y += vector_change.y
	current_chunk_start_position = Vector2(CHUNK_SIZE * current_chunk_key_x, CHUNK_SIZE * current_chunk_key_y)
	check_queue()

func create_key(x, y):
	return str(x) + "_" + str(y)
#endregion
