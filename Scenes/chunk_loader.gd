extends Node

@onready var camera = $Camera2D

const CHUNK_SIZE = 100.0
var current_chunk_index = 0

var player = null
var testcounter = 0

##
# Thoughts:
#So crete a map, that contains coordinates.
#Attach the to the coordinates a scene. 
#This scene will then be the scene that loads in that area. 
#If a player moves towards that area then reload that scene. 
#Keep track of scenes around the player in a 3x3 (likely too many). Will need to just do infront of play (arrow head)
#Need to separate the player and screen. 

##

# List of Map Segments to generate chunks
const MAP_SEGMENTS = [
	preload("res://Game_Objects/Islands/island_0.tscn"),
	preload("res://Game_Objects/Islands/island_1.tscn")
]

@onready var parent_scene = $scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	print("loading")
	#load_scene()
	var scene = MAP_SEGMENTS[0].instantiate()
	scene.position = Vector2(-8000, 0)
	parent_scene.add_child.call_deferred(scene)
	move_child(scene, 0)
	
	var scene_2 = MAP_SEGMENTS[1].instantiate()
	scene_2.position = Vector2(8000, 0)
	parent_scene.add_child.call_deferred(scene_2)
	move_child(scene_2, 1)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if testcounter < 1:
		#connect_to_parent(0)
		#testcounter += 1 
	
func load_chunk(x, y): 
	pass
	
#func load_scene():
	#var scene = load("res://Game_Objects/Islands/island_1.tscn")
	
	
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
