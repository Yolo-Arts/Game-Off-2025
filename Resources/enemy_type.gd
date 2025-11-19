extends Resource

class_name enemy_type

# Enemies have a spritesheet of 360 images
# 45 columns
# 8 rows
# 45 x 8 = 360

# dealing with weird rotation of enemy
@export var total_frames = 360
@export var frame_offset = -50

@export var type: types
@export var texture: Texture2D
@export var texture_damaged: Texture2D

@export var speed: float = 400.0

@export var damage: float
@export var health: float

enum types {
	SLOW,
	NORMAL,
	FAST
}

func find_appearance():
	var color: Color
	match type:
		0:
			color = Color(1, 0, 0.14, 1)
		1:
			color = Color(0, 0.53, 0.95, 1)
		2:
			color = Color(0, 0.85, 0.45, 1)
	return color
