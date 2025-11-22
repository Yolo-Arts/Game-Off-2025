extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $Control/TextureRect


func _ready() -> void:
	visible = true
	animation_player.play("floating")

func on_game_start():
	var tween = create_tween()
	tween.tween_property(texture_rect, "position:y", texture_rect.position.y - 3500, 2.0).from(texture_rect.position.y)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(2.0).timeout
	visible = false


func _on_isometric_main_begin_game() -> void:
	on_game_start()
