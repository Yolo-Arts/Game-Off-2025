extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var texture_rect: TextureRect = $Control/TextureRect
@onready var controls: TextureRect = %Controls
@onready var panel_container: PanelContainer = %ControlsContainer
@onready var gradient: TextureRect = $Control/Gradient
@onready var gpu_particles_2d: GPUParticles2D = $Control/GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $Control/GPUParticles2D2
@onready var begin_container: MarginContainer = $Control/BeginContainer


func _ready() -> void:
	visible = true
	animation_player.play("floating")
	animation_player_2.play("scale")

func on_game_start():
	var tween = create_tween()
	tween.tween_property(texture_rect, "position:y", texture_rect.position.y - 3500, 2.0).from(texture_rect.position.y)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween.parallel().tween_property(controls, "position:y", controls.position.y - 3500, 2.0).from(controls.position.y)\
	#.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(panel_container, "position:x", panel_container.position.x + 3500, 2.0).from(panel_container.position.x)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(gradient, "position:x", gradient.position.x - 3500, 2.0).from(gradient.position.x)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(begin_container, "position:x", begin_container.position.x + 3500, 2.0).from(begin_container.position.x)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(gpu_particles_2d, "self_modulate:a", 0, 1.5).from(1.0)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(gpu_particles_2d_2, "self_modulate:a", 0, 1.5).from(1.0)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(2.0).timeout
	visible = false


func _on_isometric_main_begin_game() -> void:
	on_game_start()
