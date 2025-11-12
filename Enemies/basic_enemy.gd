extends CharacterBody2D

class_name Enemy

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 
#FIXME Fix the hitboxes, they do not rotate with the enemy.

var speed: float = 100.0  
var health: float = 100.0  

# Particles
const DEATH_EXPLOSION = preload("uid://da1djwy4cr28t")
const DEAD_SHIP = preload("uid://cjqp43sw23woi")
const EXP_ORB = preload("res://Scenes/exp_orb.tscn")
const HIT_EXPLOSION = preload("uid://bk5p2f8p57tdj")
const SHIP__4_ = preload("uid://dtggqs3n2orf8")


signal playSound
signal playerHitSound
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hitboxArea = $Hitbox
#@onready var exp_orb: Area2D = $Exp_Orb
#@onready var damage_interval_timer = $damage_interval_timer
@onready var hurtbox = $Hurtbox
@onready var hurt_shape = $Hurtbox/hurtShape
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enemy_types: Array[Resource]
var enemy_stats: Resource

#@export var isometric_angle: float = 30.0
#var isometric_transform: Transform2D

var player = null
var isDead = false

var total_frames = 360
var frame_offset = 0  

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	#isometric_transform = Transform2D()
	#isometric_transform = isometric_transform.rotated(deg_to_rad(isometric_angle))
	
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


func _physics_process(_delta):
	if !isDead: 
		var direction = get_direction_to_player()
		#var isometric_direction = isometric_transform * direction
		#velocity = isometric_direction * speed
		velocity = direction * speed
		if direction:
			sprite.rotation = direction.angle() - deg_to_rad(90)
			#update_sprite_rotation(direction.angle())
		move_and_slide()


func get_direction_to_player():
	player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
	return Vector2.ZERO  # Return zero vector if no player found

# FIXME queue_free() enemy when they die. 

func update_sprite_rotation(angle: float):
	# Convert angle to degrees and normalize to 0-360
	var deg = rad_to_deg(angle)
	deg = fmod(deg, 360.0)
	if deg < 0: deg += 360.0

	# Calculate frame index based on your 45x8 grid
	# Each column represents a different angle (360/45 = 8 degrees per column)
	var frame_index = int(deg / 8.0)

	# Apply offset and wrap around
	frame_index = (frame_index + frame_offset) % total_frames

	# Set the frame
	sprite.frame = frame_index
	sprite.global_rotation = 0  # Keep the sprite from rotating with the transform


func take_damage(damage: int):
	health -= damage
	self.animation_player.play("hit_flash")
	playerHitSound.emit()
	spawn_hit_explosion(self.position, Vector2(0,0))
	if health <= health/2:
		sprite.texture = enemy_stats.texture_damaged
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
		playSound.emit()
		await get_tree().create_timer(2).timeout

func spawn_death_explosion(pos: Vector2, normal: Vector2) -> void:
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
	var instance = HIT_EXPLOSION.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.rotation = normal.angle()

func spawn_exp_orb(pos: Vector2):
	var instance = EXP_ORB.instantiate()
	get_tree().get_current_scene().call_deferred("add_child", instance)
	instance.global_position = pos

func disable_hitbox():
	print("disabled")
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
