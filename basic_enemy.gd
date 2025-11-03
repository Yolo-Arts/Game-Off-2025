extends CharacterBody2D

#TODO FIX THE MOVEMENT SCRIPT SO THAT THEY ACTUALLY MOVE LIKE A BOAT 

@export var speed = 150

var player = null

func _ready():
	pass

func _physics_process(delta):
	var direction = get_direction_to_player()
	velocity = direction * speed
	move_and_slide()

func get_direction_to_player():
	player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		return direction
		
func take_damage():
	queue_free()
