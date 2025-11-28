extends Enemy_iso
class_name ProjectileEnemy

@export var projectile_scene: PackedScene 
@onready var shoot_timer: Timer = $ShootTimer 

var shoot_cooldown: float
var shoot_range: float
var projectile_speed: float
var shoot_damage: float

func _ready():
	print("Projectile enemy spawned")
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	
	
	enemy_stats = enemy_types[0] 
	sprite.texture = enemy_stats.texture
	total_frames = enemy_stats.total_frames
	frame_offset = enemy_stats.frame_offset
	speed = enemy_stats.speed
	health = enemy_stats.health
	
	shoot_cooldown = enemy_stats.shoot_cooldown
	shoot_range = enemy_stats.shoot_range
	projectile_speed = enemy_stats.projectile_speed
	shoot_damage = enemy_stats.shoot_damage
	
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true 

func _physics_process(delta):
	if !isDead:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			var direction_to_player = (player.global_position - global_position).normalized()
			var distance_to_player = global_position.distance_to(player.global_position)
			
			update_sprite_rotation(direction_to_player.angle())
			
			if distance_to_player > shoot_range:
				var target_velocity = direction_to_player * speed
				velocity = velocity.lerp(target_velocity, acceleration * delta)
			else:
				velocity = velocity.lerp(Vector2.ZERO, friction * delta)
				
				if shoot_timer.is_stopped():
					shoot()
		
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider and collider.is_in_group("player") && collider.is_drifting:
				var bounce_force = 700
				take_damage(collider.ram_damage)
				apply_knockback(collider.global_position, bounce_force)
				Globals.camera.shake(0.5, 25, 25)
			elif collider:
				apply_knockback(collision.get_collider().global_position, 100)

func shoot():
	shoot_timer.start()
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.damage = shoot_damage
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		projectile.velocity = direction * projectile_speed

func update_sprite_rotation(angle: float):
	var deg = rad_to_deg(angle)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0
	var frame_index = int(deg / (360.0 / total_frames))
	frame_index = (frame_index + frame_offset + total_frames) % total_frames
	sprite.frame = frame_index
	sprite.global_rotation = 0 
