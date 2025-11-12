class_name Iso_player
extends Player

@export var isometric_angle: float = 30.0 
var isometric_transform: Transform2D

func _ready():
	health = 100
	#Globals.player_died.connect(dead_player)
	
	isometric_transform = Transform2D()
	isometric_transform = isometric_transform.rotated(deg_to_rad(isometric_angle))

func dead_player():
	Globals.player_died.emit()
	isDead = true
	for i in range(0, 5):
		spawn_death_explosion(self.global_position)
	self.hide()

func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		shoot()

func _physics_process(delta) -> void:
	if !isDead:
		var turn_direction = 0.0
		if Input.is_action_pressed("turn_left"):
			turn_direction -= 1.0
		if Input.is_action_pressed("turn_right"):
			turn_direction += 1.0
		
		if turn_direction != 0.0:
			turn_time += delta
			var turn_factor = min(1.0, turn_time * turn_acceleration)
			current_turn_speed = lerp(min_turn_speed, max_turn_speed, turn_factor)
			
			rotate(turn_direction * current_turn_speed * delta)
		else:
			turn_time = 0.0
			current_turn_speed = min_turn_speed
		
		var target_speed = 0.0
		var current_accel = 0.0

		if Input.is_action_pressed("move_forward"):
			if turn_direction != 0.0:
				target_speed = base_speed
				current_accel = deceleration 
			else:
				target_speed = max_speed
				current_accel = acceleration
		else:
			target_speed = base_speed
			current_accel = acceleration 

		current_speed = lerp(current_speed, target_speed, current_accel * delta)
		#var forward_direction = Vector2.RIGHT.rotated(rotation)
		#velocity = forward_direction * current_speed
		
		# ISOMETRIC MOVEMENT: 
		var forward_direction = Vector2.RIGHT.rotated(rotation)
		var isometric_direction = isometric_transform * forward_direction
		velocity = isometric_direction * current_speed
		
		# Wall collisions:
		var collision = move_and_collide(velocity * delta)
		if collision:
			animation_player.play("bounce")
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal) * bounce_dampening
			rotation = velocity.angle()
			spawn_bounce_particles(collision.get_position(), normal)
			Globals.camera.shake(0.15, 10, 5)
			move_and_slide()
			
		if health <= 0:
			isDead = true
			dead_player()
		
		update_sprite_rotation()


func shoot():

	Bullet_Type.shoot(cannonball, self, true)

func spawn_cannon_particles(pos: Vector2, normal: Vector2) -> void:
	var instance = cannon_fire.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()
	fire_cannon_SFX.emit()

func spawn_death_explosion(pos: Vector2) -> void:
	var instance = DEATH_EXPLOSION.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = pos

func spawn_bounce_particles(pos: Vector2, normal: Vector2) -> void:
	var instance = BOUNCE_PARTICLES.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()

func player_hit():
	playerHitSFX.emit()

@onready var boat = $boat

var total_frames = 360
var frame_offset = -10

func update_sprite_rotation():
	var deg = rad_to_deg(rotation)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0
	var frame_index = int(deg / (360.0 / total_frames))
	frame_index = (frame_index + frame_offset) % total_frames
	
	if frame_index < 0:
		frame_index += total_frames
	boat.frame = frame_index
	boat.global_rotation = 0


func _on_exp_collection_radius_area_entered(area: Area2D) -> void:
	if area is Exp_Orb:
		area.collected = true
		area.player = self

func _on_damage_area_iso_body_entered(body: Node2D) -> void:
	if $damage_interval_timer.is_stopped() and body is Enemy:
		health -= body.enemy_stats.damage
		self.player_hit()
		print("hit")
		#TODO ADD BACK HITSHOCK
		#self.animation_player.play("hit_shock")
		Globals.camera.shake(0.5, 15, 10)
		print("Player Health: ", health, "Damaged by: ", body.enemy_stats.type)
		$damage_interval_timer.start()
	else:
		print("Damage on cooldown")
