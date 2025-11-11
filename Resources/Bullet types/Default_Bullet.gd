class_name Default_bullet
extends Bullet_type

func shoot(cannonball: PackedScene, player:Player):
	
	var bullet_instance = cannonball.instantiate()
	var bullet_instance2 = cannonball.instantiate()
	
	player.get_parent().add_child(bullet_instance)
	player.get_parent().add_child(bullet_instance2)

	var ship_forward = Vector2.RIGHT.rotated(player.rotation)
	
	var leftCannonPos = player.cannon_left.global_position
	var rightCannonPos = player.cannon_right.global_position
	
	bullet_instance.global_position = leftCannonPos
	bullet_instance2.global_position = rightCannonPos
	
	# FIXME Particles do not spawn firing in the correct direction.
	var left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
	var right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	
	bullet_instance.direction = left_cannon_direction
	bullet_instance2.direction = right_cannon_direction
	
	
	spawn_cannon_particles(leftCannonPos, left_cannon_direction, player)
	spawn_cannon_particles(rightCannonPos, right_cannon_direction, player)

	Globals.camera.shake(0.25, 10, 10)

func spawn_cannon_particles(pos: Vector2, normal: Vector2, player: Player):
	var instance = player.cannon_fire.instantiate()
	player.add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()
	player.fire_cannon_SFX.emit()
