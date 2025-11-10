extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var hull = $hull
@onready var sail = $sail


func _ready():
	#var tween = create_tween()
	#tween.tween_property(hull, "modulate", Color(0.0, 0.0, 0.0, 0.0), 10.0)
	animation_player.play("sinkBoat")

func kill():
	queue_free()
