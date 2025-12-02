extends Sprite2D

@export var player: CharacterBody2D 
@export var speed_scale: Vector2 = Vector2(0.1, 0.0)

var shader_material: ShaderMaterial = null

func _ready():
	shader_material = material as ShaderMaterial
	if not shader_material:
		push_error("Sprite2D must have a ShaderMaterial assigned.")
		set_process(false)
		return
	texture_repeat = TEXTURE_REPEAT_ENABLED

func _process(_delta):
	if player and shader_material:
		var player_pos = player.global_position
		
		var new_offset = player_pos * speed_scale / texture.get_size()
		
		shader_material.set_shader_parameter("scroll_offset", new_offset)
