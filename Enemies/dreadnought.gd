extends Enemy_iso
class_name dreadnought

@export var projectile_scene: PackedScene
@onready var shoot_timer: Timer = $ShootTimer
@onready var state_timer: Timer = $StateTimer 

var shoot_cooldown: float
var shoot_range: float
var projectile_speed: float
var shoot_damage: float

var current_state: String = "aim"
var state_duration: float = 15.0 
var dash_speed: float
var dash_cooldown: float = 6.0 
var dash_cooldown_timer: float = 0.0 # 
var is_dashing: bool = false
var dash_duration: float = 0.5
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
@onready var boost_particles: CPUParticles2D = $BoostParticles_White 

func _ready():
	Signals.time_freeze.connect(_on_time_freeze)
	Signals.time_freeze_disable.connect(_on_time_freeze_disable)
	print("Projectile enemy spawned")
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	
	enemy_stats = enemy_types[0]
	sprite.texture = enemy_stats.texture
	total_frames = enemy_stats.total_frames
	frame_offset = enemy_stats.frame_offset
	speed = enemy_stats.speed
	health = enemy_stats.health
	print("Dreadnought health: ", health)
	if Globals.health_mult > 1:
		health *= Globals.health_mult * 4
		print("Dreadnought new health: ", health)
		
	shoot_cooldown = enemy_stats.shoot_cooldown
	shoot_range = enemy_stats.shoot_range
	projectile_speed = enemy_stats.projectile_speed
	shoot_damage = enemy_stats.shoot_damage
	
	dash_speed = enemy_stats.dash_speed
	dash_cooldown = enemy_stats.dash_cooldown
	
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	
	state_timer.wait_time = state_duration
	state_timer.timeout.connect(_on_state_timer_timeout)
	
	change_state("aim")


func change_state(new_state: String):
	current_state = new_state
	print("Dreadnought entered state: ", current_state)
	
	is_dashing = false
	if boost_particles:
		boost_particles.emitting = false
	
	state_timer.start()

func _on_state_timer_timeout():
	if current_state == "aim":
		change_state("dash")
	elif current_state == "dash":
		change_state("aim")


func _physics_process(delta):
	if !isDead and can_move:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		
		var player = get_tree().get_first_node_in_group("player")
		if !player:
			velocity = velocity.lerp(Vector2.ZERO, friction * delta)
			move_and_slide()
			return
		
		var direction_to_player = (player.global_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if current_state == "aim":
			handle_aim_state(delta, direction_to_player, distance_to_player)
		elif current_state == "dash":
			handle_dash_state(delta, direction_to_player)
		
		update_sprite_rotation(velocity.angle())
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider and collider.is_in_group("player"):
				if collider.is_drifting:
					if "enemies_hit_by_drift" in collider and not collider.enemies_hit_by_drift.has(self):
						var bounce_force = 700
						take_damage(collider.ram_damage)
						collider.enemies_hit_by_drift.append(self)
						apply_knockback(collider.global_position, bounce_force)
						Globals.camera.shake(0.5, 25, 25)
				
				else:
					apply_knockback(collider.global_position, 100)
			
			elif collider:
				apply_knockback(collision.get_collider().global_position, 100)

func handle_aim_state(delta: float, direction_to_player: Vector2, distance_to_player: float):
	if distance_to_player > shoot_range:
		var target_velocity = direction_to_player * speed
		velocity = velocity.lerp(target_velocity, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta) 
		
		if shoot_timer.is_stopped():
			shoot()

func handle_dash_state(delta: float, direction_to_player: Vector2):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			if boost_particles:
				boost_particles.emitting = false
		else:
			velocity = dash_direction * dash_speed
	else:
		var target_velocity = direction_to_player * speed
		velocity = velocity.lerp(target_velocity, acceleration * delta)
		
		if dash_cooldown_timer <= 0:
			start_dash(direction_to_player)

func start_dash(direction: Vector2):
	print("Starting dash!")
	is_dashing = true
	if boost_particles:
		boost_particles.emitting = true
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown
	dash_direction = direction.normalized()

func shoot():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	shoot_timer.start()
		
	_shoot_burst(player.global_position, 0)

func _shoot_burst(target_position: Vector2, shot_count: int):
	if shot_count >= 5:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	
	var base_direction = (player.global_position - global_position).normalized()
	var spread_angle = 15.0 

	for i in range(-1, 2): 
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.damage = shoot_damage
		var angle_offset = float(i) * spread_angle
		var spread_direction = base_direction.rotated(deg_to_rad(angle_offset))
		
		projectile.velocity = spread_direction * projectile_speed
		
	var delay_timer = Timer.new()
	add_child(delay_timer)
	delay_timer.wait_time = 0.25
	delay_timer.one_shot = true
	delay_timer.timeout.connect(func():
		_shoot_burst(target_position, shot_count + 1)
		delay_timer.queue_free()
	)
	delay_timer.start()

func update_sprite_rotation(angle: float):
	var deg = rad_to_deg(angle)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0
	var frame_index = int(deg / (360.0 / total_frames))
	frame_index = (frame_index + frame_offset + total_frames) % total_frames
	sprite.frame = frame_index
	sprite.global_rotation = 0

@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2


func disable_hitbox():
	Globals.update_score("BOSSES_SHIPWRECKED")
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
	if collision_shape_2d_2:
		collision_shape_2d_2.set_deferred("disabled", true)
		collision_shape_2d_2.queue_free()
