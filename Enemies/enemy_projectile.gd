extends Area2D
class_name Enemy_Bullet

var velocity: Vector2 = Vector2.ZERO
var damage: float
@onready var timer: Timer = $Timer

func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body):
	print("Body hit: ", body)
	if body.is_in_group("player"):
		SoundManager.play_PlayerHurt()
		print("Hit player")
		body.take_damage(damage)
	queue_free() 


func _on_timer_timeout() -> void:
	queue_free()
