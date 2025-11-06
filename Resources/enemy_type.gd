extends Resource

class_name enemy_type

@export var type: types
@export var texture: Texture2D

@export var speed: float = 200.0

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
