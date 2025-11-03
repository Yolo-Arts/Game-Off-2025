extends CharacterBody2D

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 

@export var speed = 200


@onready var sprite = $Sprite2D


@export var enemy_types: Array[Resource]
var enemy_stats: Resource

var player = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	enemy_stats = enemy_types[randi_range(0, enemy_types.size() - 1)]
	if enemy_stats.texture:
		sprite.texture = enemy_stats.texture

func _physics_process(_delta):
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
	queue_free()
