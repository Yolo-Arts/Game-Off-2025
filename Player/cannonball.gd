class_name Cannonball
extends Area2D

@export var max_pierce := 1
@export var speed = 700
var base_damage = 10
var chain = 0
var tween: Tween
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
	if chain == 0:
		current_pierce_count += 1
	
	if current_pierce_count >= max_pierce and !is_chainable():
		queue_free()
	
		
	if body.has_method("take_damage"):
		body.take_damage(base_damage)

	while is_chainable():
		var furthest_enemy = find_furthest_enemy(body)
		tween = create_tween()
		tween.tween_property(self, "global_position", furthest_enemy.global_position, 0.05)
		await tween.finished
		chain -= 1
		
	if explosive:
		explode()

func explode():
	#play explosion effect
	var enemies = explosion_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(base_damage)
			
func find_furthest_enemy(exclude: Enemy_iso) -> Enemy_iso:
	var nearby_enemies = explosion_area.get_overlapping_bodies()
	var furthest_index = 0
	var furthest_distance = 0.0
	var current_distance
	
	for enemy in nearby_enemies:
		if enemy == exclude:
			continue
		var index = nearby_enemies.find(enemy)
		current_distance = (global_position.distance_squared_to(enemy.global_position))
		if furthest_distance <= current_distance:
			furthest_distance = current_distance
			furthest_index = index
			
	
	return nearby_enemies[furthest_index]

func is_chainable() -> bool:
	if explosion_area.get_overlapping_bodies().size() > 1 and chain > 0:
		return true
	else:
		return false
