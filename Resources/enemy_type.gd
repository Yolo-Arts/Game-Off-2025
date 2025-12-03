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

@export var damage: float = 10
@export var health: float = 20
@export var acceleration: float = 1.2

@export var can_dash: bool = false
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.5
@export var dash_cooldown: float = 3.0

@export var can_shoot: bool = false
@export var shoot_cooldown: float = 5.0
@export var shoot_damage: float = 15.0
@export var shoot_range: float = 500.0  
@export var projectile_speed: float = 400.0

@export var is_boss: bool = false

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
