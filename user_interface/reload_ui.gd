extends Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var parent_reload_ui: Node2D = $ParentReloadUI

func _ready() -> void:
	parent_reload_ui.visible = false

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	parent_reload_ui.global_position = player.global_position

func play():
	animation_player.play("reload")
