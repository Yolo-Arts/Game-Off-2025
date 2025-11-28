extends Node2D
class_name Cannonball_shot


func get_cannonballs() -> Array[Node]:
	return get_children()

func get_cannonball() -> Cannonball:
	return get_cannonballs()[0]
	
func set_cannonball_damage(damage: float):
	for ball in get_children():
		ball.base_damage = damage

func set_cannonball_scale(scale: Vector2):
	for ball in get_cannonballs():
		ball.apply_scale(scale)
		#ball.explosion_area.apply_scale(Vector2(0.5, 0.5))

func set_cannonball_direction(direction: Vector2):
	for ball in get_children():
		ball.direction = direction

func set_explosive():
	for ball in get_children():
		ball.explosive = true

func add_cannonball(amount:int, spread: float):
	var cannonball = get_cannonball()
	for i in range(amount):
		self.add_child(cannonball.duplicate())
	
	var cannonballs = get_cannonballs()
	var length = cannonballs.size()
	for cannonball_i in cannonballs:
		var index = cannonballs.find(cannonball_i)
		cannonball_i.position += Vector2(0,(length - (index+1))*spread - (length-1)*spread/2)
		
func set_lightning(lightning_chain: int):
	for cannonball in get_cannonballs():
		cannonball.chain = lightning_chain
	
