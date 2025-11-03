extends CharacterBody2D

# TODO Make it so that W makes the player move, rather than constant speed.

@export var base_speed: float = 150.0
@export var max_speed: float = 500.0
@export var min_turn_speed: float = 0.8  
@export var max_turn_speed: float = 4.0  
@export var turn_acceleration: float = 0.3
@export var acceleration: float = 1.0
@export var deceleration: float = 0.5

# Cannons
@onready var cannon_left = $CannonLeft
@onready var cannon_right = $CannonRight

# Cannonball
@onready var cannonball = preload("uid://m1jsvblrkbdq")

# Particles
@export var cannon_fire: PackedScene = preload("uid://do1jur5t8qgko") 

var current_speed: float = 300.0
var current_turn_speed: float = min_turn_speed  
var turn_time: float = 0.0 

func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		shoot()

func _physics_process(delta) -> void:
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
		current_speed = lerp(current_speed, base_speed, deceleration * delta)
		#print("Turning with speed: ", current_turn_speed, " Deaccelerating: ", current_speed)
	else:
		turn_time = 0.0
		current_turn_speed = min_turn_speed
		
		current_speed = lerp(current_speed, max_speed, acceleration * delta)
		#print("Accelerating: ", current_speed)
	
	var forward_direction = Vector2.RIGHT.rotated(rotation)
	velocity = forward_direction * current_speed
	
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
