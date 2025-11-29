class_name Exp_Orb
extends Area2D

var velocity = Vector2(0, 0)
var faster = 100.00
var speed = 0
var player: Player
var collected = false
var direction_to_player = Vector2(0,0)
var is_all_collect :bool

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.collect_all_exp.connect(_on_collect_all_exp)
	var random = randf_range(0,1)
	if random < 0.99:
		is_all_collect = false
	elif random >= 0.99:
		is_all_collect = true
		sprite_2d.set_modulate(Color(200, 0, 0))
	
func _physics_process(delta: float) -> void:
	if collected:
		speed = player.base_speed + faster
		direction_to_player = get_direction_to_player()
		velocity = direction_to_player*speed
		global_position = global_position + velocity*delta
		if is_all_collect:
			Signals.collect_all_exp.emit(player)

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

func _on_collect_all_exp(to_player: Player):
	player = to_player
	collected = true
	
