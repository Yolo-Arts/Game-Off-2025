# BackgroundController.gd script
extends Sprite2D

@export var player: CharacterBody2D # Drag your Player node here in the editor
@export var speed_scale: Vector2 = Vector2(0.1, 0.0) # Controls parallax speed (0.1 means 10% movement)

var shader_material: ShaderMaterial = null

func _ready():
	# 1. Get the ShaderMaterial
	shader_material = material as ShaderMaterial
	if not shader_material:
		push_error("Sprite2D must have a ShaderMaterial assigned.")
		set_process(false)
		return

	# 2. Set the texture properties to enable tiling (if using a large texture that needs to repeat)
	# This is a good practice for parallax backgrounds.
	texture_repeat = TEXTURE_REPEAT_ENABLED

func _process(_delta):
	if player and shader_material:
		# Get the player's global position.
		var player_pos = player.global_position
		
		# Calculate the scrolling offset.
		# We multiply by speed_scale to control the PARALLAX effect.
		# Note: We divide by the texture size to get a UV (0-1) value, which is 
		# what the shader expects for seamless tiling.
		var new_offset = player_pos * speed_scale / texture.get_size()
		
		# Pass the offset to the shader.
		# Since you wanted movement in the **opposite direction**, 
		# you need to pass the NEGATIVE value.
		shader_material.set_shader_parameter("scroll_offset", new_offset)
