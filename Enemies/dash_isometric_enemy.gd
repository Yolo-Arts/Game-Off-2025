extends Enemy_iso
class_name DashIsometricEnemy

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

var can_dash: bool = true
var dash_speed: float = 800.0
var dash_duration: float = 0.5
var dash_cooldown: float = 3.0
@onready var dash_warning: GPUParticles2D = $DashWarning
@onready var boost_particles: GPUParticles2D = $BoostParticles_White
@onready var boost_indicator: GPUParticles2D = $boostIndicator

func _ready():
	
	print("Dash enemy spawned")
	#print("Enemy dash speed: ", enemy_types[0].dash_speed)
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	
	
	enemy_stats = enemy_types[0]
	sprite.texture = enemy_stats.texture
	total_frames = enemy_stats.total_frames
	frame_offset = enemy_stats.frame_offset
	speed = enemy_stats.speed
	health = enemy_stats.health
	var damage = enemy_stats.damage
	can_dash = enemy_stats.can_dash
	dash_speed = enemy_stats.dash_speed
	dash_duration = enemy_stats.dash_duration
	dash_cooldown = enemy_stats.dash_cooldown
	dash_cooldown_timer = dash_cooldown * 0.5

#func set_enemy_type(enemy_type: int):
	#if enemy_stats:
		#print("Enemy has stats")
		#can_dash = enemy_stats.can_dash
		#dash_speed = enemy_stats.dash_speed
		#dash_duration = enemy_stats.dash_duration
		#dash_cooldown = enemy_stats.dash_cooldown
		#dash_cooldown_timer = dash_cooldown * 0.5  # Reset cooldown
		#print("Dash enemy initialized with cooldown: ", dash_cooldown_timer)
	#else:
		#print("Enemy does not have stats")

func _physics_process(delta):
	if !isDead:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		
		if is_dashing:
			dash_timer -= delta
			if dash_timer <= 0:
				is_dashing = false
			else:
				velocity = dash_direction * dash_speed
				if velocity.length() > 10:
					update_sprite_rotation(velocity.angle())
		else:
			var direction = get_direction_to_player()
			var target_velocity = Vector2.ZERO
			
			if direction != Vector2.ZERO:
				target_velocity = direction * speed
				velocity = velocity.lerp(target_velocity, acceleration * delta)
				
				if velocity.length() > 10:
					update_sprite_rotation(velocity.angle())
					

					if can_dash and dash_cooldown_timer <= 0:

						var player = get_tree().get_first_node_in_group("player")
						if player:
							var distance_to_player = global_position.distance_to(player.global_position)
							if distance_to_player > 100 and distance_to_player < 1800:
								#boost_indicator.emitting = true
								if randf() < 0.02:  # 2% chance 
									start_dash(direction)
			else:
				velocity = velocity.lerp(Vector2.ZERO, friction * delta)
		
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

func start_dash(direction: Vector2):
	print("Starting dash!")
	is_dashing = true
	#dash_warning.emitting = true
	boost_particles.emitting = true
	dash_timer = dash_duration  
	dash_cooldown_timer = dash_cooldown  
	dash_direction = direction.normalized()
	
	

func update_sprite_rotation(angle: float):
	var deg = rad_to_deg(angle)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0
	var frame_index = int(deg / (360.0 / total_frames))
	frame_index = (frame_index + frame_offset + total_frames) % total_frames
	sprite.frame = frame_index
	sprite.global_rotation = 0 
