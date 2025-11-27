class_name Cannonball
extends Area2D

@export var max_pierce := 1
@export var speed = 700
var base_damage = 10

# In the scenario we use resources to manage bullet types
@export var bullet: Resource
@onready var sprite = $Sprite2D
@onready var explosion_area: Area2D = $"Explosion area"

var direction = Vector2.ZERO

var current_pierce_count := 0
var explosive = false

func _ready():
	#if !bullet:
		#return
	#sprite.texture = bullet.texture
	#set_modulate(bullet.find_appearance()) 
	pass

func _physics_process(delta):
	#if !bullet:
		#return
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	current_pierce_count += 1
	
	if current_pierce_count >= max_pierce:
		queue_free()
	
	if body.has_method("take_damage"):
		body.take_damage(base_damage)
	if explosive:
		explode()

func explode():
	#play explosion effect
	var enemies = explosion_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(base_damage)
			
