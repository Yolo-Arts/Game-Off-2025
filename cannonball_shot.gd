extends Node2D
class_name Cannonball_shot

@onready var cannonball: Cannonball = $cannonball

func get_cannonballs() -> Array[Node]:

	return get_children()
	
func set_cannonball_damage(damage: float):
	for ball in get_children():
		ball.base_damage = damage

func set_cannonball_direction(direction: Vector2):
	for ball in get_children():
		ball.direction = direction
