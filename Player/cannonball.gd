extends Area2D

@export var speed = 700
var base_damage = 10

# In the scenario we use resources to manage bullet types
@export var bullet: Resource
@onready var sprite = $Sprite2D

var direction = Vector2.ZERO

func _ready():
	if !bullet:
		return
	sprite.texture = bullet.texture
	set_modulate(bullet.find_appearance())

func _physics_process(delta):
	#if !bullet:
		#return
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(base_damage)
