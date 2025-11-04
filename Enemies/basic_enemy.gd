extends CharacterBody2D

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 

@export var speed = 200
const DEATH_EXPLOSION = preload("uid://da1djwy4cr28t")
const DEAD_SHIP = preload("uid://cjqp43sw23woi")

signal playSound

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hitboxArea = $Hitbox
@onready var navigator := $NavigationAgent2D as NavigationAgent2D



@export var enemy_types: Array[Resource]
var enemy_stats: Resource


var isDead = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	enemy_stats = enemy_types[randi_range(0, enemy_types.size() - 1)]
	if enemy_stats.texture:
		sprite.texture = enemy_stats.texture

func _physics_process(_delta: float) -> void:
	get_direction_to_player()
	var direc = to_local(navigator.get_next_path_position()).normalized()
	velocity = direc * speed
	move_and_slide()

func makepath() -> void:
	navigator.target_position = player.global_position

func get_direction_to_player():
	if player:
		var direction = to_local(navigator.get_next_path_position()).normalized()
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


@warning_ignore("unused_parameter")
func spawn_death_explosion(pos: Vector2, normal: Vector2) -> void:
	var instance = DEATH_EXPLOSION.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = pos

@warning_ignore("unused_parameter")
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


func _on_timer_timeout() -> void:
	makepath()
