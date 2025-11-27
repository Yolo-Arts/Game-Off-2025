class_name Default_bullet
extends Bullet_type



func shoot(cannonball_scene: PackedScene, player:Player, isometric = false, scale = 1.0):
	var cannonball_shot = cannonball_scene.instantiate()
	var upgraded_cannon_ball = apply_cannonball_upgrades(cannonball_shot)
	var upgraded_cannon_ball2 = upgraded_cannon_ball.duplicate()
	
	var bullet_instance = upgraded_cannon_ball
	var bullet_instance2 = upgraded_cannon_ball2
	
	print(bullet_instance.get_cannonballs())
	
	#var left_bullets :Array[Cannonball]
	#var right_bullets :Array[Cannonball]
	#
	#left_bullets.append(bullet_instance)
	#right_bullets.append(bullet_instance2)
	
	bullet_instance.set_cannonball_damage(player.damage)
	bullet_instance2.set_cannonball_damage(player.damage)
	
	bullet_instance.apply_scale(Vector2(scale, scale))
	bullet_instance2.apply_scale(Vector2(scale, scale))

	
	player.get_parent().add_child(bullet_instance)
	player.get_parent().add_child(bullet_instance2)

	var ship_forward = Vector2.RIGHT.rotated(player.rotation)
	
	
	var leftCannonPos = player.cannon_left.global_position
	var rightCannonPos = player.cannon_right.global_position
	
	bullet_instance.global_position = leftCannonPos
	bullet_instance2.global_position = rightCannonPos
	
	# FIXME Particles do not spawn firing in the correct direction.
	
	if isometric:
		var isometric_forward = player.isometric_transform * ship_forward
		left_cannon_direction = isometric_forward.rotated(deg_to_rad(-90)) 
		right_cannon_direction = isometric_forward.rotated(deg_to_rad(90)) 
	else:
		left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
		right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	
	bullet_instance.set_cannonball_direction(left_cannon_direction)
	bullet_instance2.set_cannonball_direction(right_cannon_direction)
	
	
	spawn_cannon_particles(leftCannonPos, left_cannon_direction, player)
	spawn_cannon_particles(rightCannonPos, right_cannon_direction, player)

	Globals.camera.shake(0.25, 10, 10)

#func iso_shoot(cannonball: PackedScene, player: Player):
	#var bullet_instance = cannonball.instantiate()
	#var bullet_instance2 = cannonball.instantiate()
	#
	#apply_cannonball_upgrades(bullet_instance)
	#apply_cannonball_upgrades(bullet_instance2)
	#
	#player.get_parent().add_child(bullet_instance)
	#player.get_parent().add_child(bullet_instance2)
#
	#var ship_forward = Vector2.RIGHT.rotated(player.rotation)
	#
	#var isometric_forward = player.isometric_transform * ship_forward
	#
	#var leftCannonPos = player.cannon_left.global_position
	#var rightCannonPos = player.cannon_right.global_position
	#
	#bullet_instance.global_position = leftCannonPos
	#bullet_instance2.global_position = rightCannonPos
	#
	## FIXME Particles do not spawn firing in the correct direction.
	##var left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
	##var right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	#
	#var left_cannon_direction = isometric_forward.rotated(deg_to_rad(-90)) 
	#var right_cannon_direction = isometric_forward.rotated(deg_to_rad(90)) 
	#
	#bullet_instance.direction = left_cannon_direction
	#bullet_instance2.direction = right_cannon_direction
	#
	#
	#spawn_cannon_particles(leftCannonPos, left_cannon_direction, player)
	#spawn_cannon_particles(rightCannonPos, right_cannon_direction, player)
	#
	#Globals.camera.shake(0.25, 10, 10)
	
func spawn_cannon_particles(pos: Vector2, normal: Vector2, player: Player):
	var instance = player.cannon_fire.instantiate()
	player.add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()
