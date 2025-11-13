class_name Double_Shot
extends Bullet_type

var spread_between_cannonballs = 20.00

func shoot(cannonball: PackedScene, player:Player, isometric = false):
	
	var bullet_instance = cannonball.instantiate()
	var bullet_instance2 = cannonball.instantiate()
	var bullet_instance3 = cannonball.instantiate()
	var bullet_instance4 = cannonball.instantiate()
	
	player.get_parent().add_child(bullet_instance)
	player.get_parent().add_child(bullet_instance2)
	player.get_parent().add_child(bullet_instance3)
	player.get_parent().add_child(bullet_instance4)
	
	var leftCannonPos = player.cannon_left.global_position
	var rightCannonPos = player.cannon_right.global_position
	
	bullet_instance.global_position = leftCannonPos - Vector2(0, spread_between_cannonballs)
	bullet_instance2.global_position = rightCannonPos - Vector2(0, spread_between_cannonballs)
	bullet_instance3.global_position = leftCannonPos + Vector2(0, spread_between_cannonballs)
	bullet_instance4.global_position = rightCannonPos + Vector2(0, spread_between_cannonballs)
	
	var ship_forward = Vector2.RIGHT.rotated(player.rotation)
	
	if isometric:
		var isometric_forward = player.isometric_transform * ship_forward
		left_cannon_direction = isometric_forward.rotated(deg_to_rad(-90)) 
		right_cannon_direction = isometric_forward.rotated(deg_to_rad(90)) 
	else:
		left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
		right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	
	bullet_instance.direction = left_cannon_direction
	bullet_instance2.direction = right_cannon_direction
	bullet_instance3.direction = left_cannon_direction
	bullet_instance4.direction = right_cannon_direction
	
	spawn_cannon_particles(leftCannonPos, left_cannon_direction, player)
	spawn_cannon_particles(rightCannonPos, right_cannon_direction, player)

	Globals.camera.shake(0.25, 10, 10)

func iso_shoot(cannonball: PackedScene, player: Player):
	
	var bullet_instance = cannonball.instantiate()
	var bullet_instance2 = cannonball.instantiate()
	var bullet_instance3 = cannonball.instantiate()
	var bullet_instance4 = cannonball.instantiate()
	
	player.get_parent().add_child(bullet_instance)
	player.get_parent().add_child(bullet_instance2)
	player.get_parent().add_child(bullet_instance3)
	player.get_parent().add_child(bullet_instance4)
	
	var leftCannonPos = player.cannon_left.global_position
	var rightCannonPos = player.cannon_right.global_position
	
	bullet_instance.global_position = leftCannonPos - Vector2(0, spread_between_cannonballs)
	bullet_instance2.global_position = rightCannonPos - Vector2(0, spread_between_cannonballs)
	bullet_instance3.global_position = leftCannonPos + Vector2(0, spread_between_cannonballs)
	bullet_instance4.global_position = rightCannonPos + Vector2(0, spread_between_cannonballs)
	
	var ship_forward = Vector2.RIGHT.rotated(player.rotation)
	
	left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
	right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	
	bullet_instance.direction = left_cannon_direction
	bullet_instance2.direction = right_cannon_direction
	bullet_instance3.direction = left_cannon_direction
	bullet_instance4.direction = right_cannon_direction
	
	spawn_cannon_particles(leftCannonPos, left_cannon_direction, player)
	spawn_cannon_particles(rightCannonPos, right_cannon_direction, player)

	Globals.camera.shake(0.25, 10, 10)
	
func spawn_cannon_particles(pos: Vector2, normal: Vector2, player: Player):
	var instance = player.cannon_fire.instantiate()
	player.add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()
	#player.fire_cannon_SFX.emit()
