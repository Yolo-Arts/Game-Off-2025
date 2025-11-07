extends Node2D

@onready var water: TileMapLayer = $Tilemap/Water
@onready var sand: TileMapLayer = $Tilemap/Sand
@onready var grass: TileMapLayer = $Tilemap/Grass
@onready var rocks_and_plant: TileMapLayer = $"Tilemap/Rocks and plant"

var terrain_set = 0
var sand_terrain_int = 0
var water_terrain_int = 1
var grass_terrain_int = 2
var rock_terrain_int = 3

@export var  noise_height_texture : NoiseTexture2D
@export var width := 500
@export var height := 500
@export_range(0, 1, 0.01) var land_to_water_ratio

var noise: Noise

var source_id = 0
var water_atlas = Vector2i(8, 4)
var land_atlas = Vector2i(1, 1)

var water_tiles_array = []
var sand_tiles_array = []
var grass_tiles_array = []
var rock_tiles_array = []


var noise_array = []

func _ready() -> void:
	noise = noise_height_texture.noise
	generate_world()

func find_noise_range(noise: Noise) -> float:
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var current_noise_val = noise.get_noise_2d(x, y)
			
			noise_array.append(current_noise_val)
	var max_noise_val = noise_array.max()
	var min_noise_val = noise_array.min()
	
	var noise_mean = (max_noise_val + min_noise_val)/2
	
	var land_threshold = noise_mean - (max_noise_val - min_noise_val)/2*(2*land_to_water_ratio-1)
	
	return land_threshold
	
	

func generate_world() -> void:
	var land_threshold = find_noise_range(noise)
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var current_coord = Vector2i(x, y)
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val > land_threshold:
				#place land tile
				sand_tiles_array.append(current_coord)
				

			elif noise_val < land_threshold:
				#place sea tile
				water_tiles_array.append(current_coord)
			
	
	sand.set_cells_terrain_connect(sand_tiles_array, terrain_set, sand_terrain_int)
	water.set_cells_terrain_connect(water_tiles_array, terrain_set, water_terrain_int)
	
	print("highest:", noise_array.max())
	print("lowest:", noise_array.min())
