class_name Exp_Orb
extends Area2D

var velocity = Vector2(0, 0)
var faster = 50.00
var speed = 0
var player: Player
var collected = false
var direction_to_player = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	if collected:
		speed = player.base_speed + faster
		direction_to_player = get_direction_to_player()
		velocity = direction_to_player*speed
		global_position = global_position + velocity*delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.exp_collected.emit()
		queue_free()
	return

func get_direction_to_player():
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
	return Vector2.ZERO  # Return zero vector if no player found
