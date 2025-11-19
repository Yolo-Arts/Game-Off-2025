extends Enemy
class_name Enemy_iso

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 
#FIXME Fix the hitboxes, they do not rotate with the enemy.

const DAMAGE_NUMBERS = preload("uid://xuhrxjj8flhn")


func _ready() -> void:
	
	if enemy_stats and enemy_stats.texture:
		sprite.texture = enemy_stats.texture

	if sprite.material:
		sprite.material = sprite.material.duplicate()

func set_enemy_type(enemy_type: int):
	if enemy_type >= enemy_types.size(): 
		return
	enemy_stats = enemy_types[enemy_type]
	speed = enemy_stats.speed
	health = enemy_stats.health
	total_frames = enemy_stats.total_frames
	frame_offset = enemy_stats.frame_offset


func _physics_process(_delta):
	if !isDead: 
		var direction = get_direction_to_player()
		velocity = direction * speed
		if direction:
			update_sprite_rotation(direction.angle())
		move_and_slide()


func get_direction_to_player():
	player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
	return Vector2.ZERO  # Return zero vector if no player found

func update_sprite_rotation(angle: float):
	var deg = rad_to_deg(angle)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0
	var frame_index = int(deg / (360.0 / total_frames))
	frame_index = (frame_index + frame_offset + total_frames) % total_frames
	sprite.frame = frame_index
	sprite.global_rotation = 0 


func take_damage(damage: int):
	var damage_text = DAMAGE_NUMBERS.instantiate() as Node2D
	get_tree().current_scene.add_child(damage_text)
	
	damage_text.global_position = global_position + Vector2(randi_range(-20, 20), randi_range(-90, -100))
	damage_text.start(str(damage))
	
	health -= damage
	self.animation_player.play("hit_flash")
	spawn_hit_explosion(self.position, Vector2(0,0))
	if health <= health/2:
		# TODO Make damaged texture
		#sprite.texture = enemy_stats.texture_damaged
		speed = speed/2
	if health < 0:
		spawn_dead_ship(self.position, get_direction_to_player())
		spawn_death_explosion(self.position, Vector2(0,0))
		spawn_exp_orb(self.position)
		sprite.visible = false
		isDead = true
		disable_hitbox() 
		Globals.camera.shake(0.20, 15, 20)
		Globals.update_score("ENEMY_SHIPWRECKED")
		await get_tree().create_timer(2).timeout



func spawn_death_explosion(pos: Vector2, normal: Vector2) -> void:
	SoundManager.play_DeathExplosions()
	var instance = DEATH_EXPLOSION.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = pos
	#instance.rotation = normal.angle()

func spawn_dead_ship(pos: Vector2, normal:Vector2) -> void:
	var instance = DEAD_SHIP.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.rotation = get_direction_to_player().angle() + deg_to_rad(180)
	$queue_free.start()
	

func spawn_hit_explosion(pos: Vector2, normal:Vector2) -> void:
	SoundManager.play_EnemyHit()
	var instance = HIT_EXPLOSION.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()

func disable_hitbox():
	#print("disabled")
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)
		collision_shape_2d.queue_free()
	if hitboxArea:
		hitboxArea.set_deferred("monitorable", false)
		hitboxArea.queue_free()
	if hurtbox:
		hurtbox.set_deferred("monitorable", false)
		hurtbox.queue_free()
	if hurt_shape:
		hurt_shape.set_deferred("disabled", true)
		hurt_shape.queue_free()
	

func _on_queue_free_timeout() -> void:
	self.queue_free()
