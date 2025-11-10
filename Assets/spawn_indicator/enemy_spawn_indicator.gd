extends Sprite2D

@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("spawn_indicator")

func delete():
	queue_free()
