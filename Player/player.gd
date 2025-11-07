extends CharacterBody2D

# movement related code
@export_group("Movement Parameters")
@export var base_speed: float = 400
@export var max_speed: float = 700.0
@export var min_turn_speed: float = 0.8  
@export var max_turn_speed: float = 6.0  
@export var turn_acceleration: float = 0.4
@export var acceleration: float = 1.0
@export var deceleration: float = 0.15
@export var bounce_dampening: float = 0.7

# Cannons
@onready var cannon_left = $CannonLeft
@onready var cannon_right = $CannonRight

# Cannonball
@onready var cannonball = preload("uid://m1jsvblrkbdq")

@onready var animation_player = $AnimationPlayer

# Particles
@export_group("Particles")
@export var cannon_fire: PackedScene = preload("uid://do1jur5t8qgko") 
const DEATH_EXPLOSION = preload("uid://da1djwy4cr28t")
const BOUNCE_PARTICLES = preload("uid://mr7hf4xv0s7j")


# Sounds
signal fire_cannon_SFX
@onready var player_hurt_sfx = $PlayerHurtSFX


var current_speed: float = 300.0
var current_turn_speed: float = min_turn_speed  
var turn_time: float = 0.0 

var isDead = false

func _ready():
	Globals.player_died.connect(dead_player)

func dead_player():
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
		var forward_direction = Vector2.RIGHT.rotated(rotation)
		velocity = forward_direction * current_speed
		
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


func shoot():
	var bullet_instance = cannonball.instantiate()
	var bullet_instance2 = cannonball.instantiate()
	
	get_parent().add_child(bullet_instance)
	get_parent().add_child(bullet_instance2)

	var ship_forward = Vector2.RIGHT.rotated(rotation)
	
	var leftCannonPos = cannon_left.global_position
	var rightCannonPos = cannon_right.global_position
	
	bullet_instance.global_position = leftCannonPos
	bullet_instance2.global_position = rightCannonPos
	
	# FIXME Particles do not spawn firing in the correct direction.
	var left_cannon_direction = ship_forward.rotated(deg_to_rad(-90)) 
	var right_cannon_direction = ship_forward.rotated(deg_to_rad(90)) 
	
	bullet_instance.direction = left_cannon_direction
	bullet_instance2.direction = right_cannon_direction
	
	
	spawn_cannon_particles(leftCannonPos, left_cannon_direction)
	spawn_cannon_particles(rightCannonPos, right_cannon_direction)
	
	Globals.camera.shake(0.25, 10, 10)

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

signal playerHitSFX

func player_hit():
	playerHitSFX.emit()
