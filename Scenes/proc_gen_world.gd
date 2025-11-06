extends Node2D

@onready var tile_map: TileMap = $TileMap
@export var  noise_height_texture : NoiseTexture2D
@export var width := 500
@export var height := 500

var noise: Noise

var source_id = 0
var water_atlas = Vector2i(8, 4)
var land_atlas = Vector2i(1, 1)

var sand_tiles_array = []
var terrain_sand_int 
var grass_tiles_array = []


var noise_array = []

func _ready() -> void:
	noise = noise_height_texture.noise
	generate_world()

func generate_world() -> void:
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val > 0.2:
				#place land tile
				tile_map.set_cell(0, Vector2(x, y), source_id, land_atlas)

			elif noise_val < 0.2:
				#place sea tile
				tile_map.set_cell(0, Vector2(x, y), source_id, water_atlas)
			
			noise_array.append(noise_val)
			
	print("highest:", noise_array.max())
	print("lowest:", noise_array.min())
