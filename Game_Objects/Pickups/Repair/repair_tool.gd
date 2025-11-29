class_name Repair
extends Area2D

var velocity = Vector2(0, 0)
var faster = 100.00
var speed = 0
var player: Player
var collected = false
var direction_to_player = Vector2(0,0)
	
func _physics_process(delta: float) -> void:
	if collected:
		speed = player.base_speed + faster
		direction_to_player = get_direction_to_player()
		velocity = direction_to_player*speed
		global_position = global_position + velocity*delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Signals.repair_collected.emit()
	return

func get_direction_to_player():
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
	return Vector2.ZERO  
