extends CharacterBody2D

class_name Enemy

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 
#FIXME Fix the hitboxes, they do not rotate with the enemy.

@export var speed = 200
const DEATH_EXPLOSION = preload("uid://da1djwy4cr28t")
const DEAD_SHIP = preload("uid://cjqp43sw23woi")

signal playSound

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hitboxArea = $Hitbox
@onready var damage_interval_timer = $damage_interval_timer
@onready var hurtbox = $Hurtbox
@onready var hurt_shape = $Hurtbox/hurtShape



@export var enemy_types: Array[Resource]
var enemy_stats: Resource

var player = null
var isDead = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	enemy_stats = enemy_types[randi_range(0, enemy_types.size() - 1)]
	if enemy_stats.texture:
		sprite.texture = enemy_stats.texture

func _physics_process(_delta):
	if !isDead: 
		var direction = get_direction_to_player()
		velocity = direction * speed
		if direction:
			sprite.rotation = direction.angle() - deg_to_rad(90)
		move_and_slide()


func get_direction_to_player():
	player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
	return Vector2.ZERO  # Return zero vector if no player found

func take_damage():
	spawn_dead_ship(self.position, get_direction_to_player())
	spawn_death_explosion(self.position, Vector2(0,0))
	sprite.visible = false
	isDead = true
	disable_hitbox()
	Globals.camera.shake(0.20, 15, 20)
	playSound.emit()


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
	


#TODO add a signal to make sure that the timer works properly
func _on_hurtbox_body_entered(body):
	if body == player && damage_interval_timer.is_stopped():
		Globals.player_health -= enemy_stats.damage
		print("Player Health: ", Globals.player_health, "Damaged by: ", enemy_stats.type)
		damage_interval_timer.start()
	else:
		print("Damage on cooldown")
