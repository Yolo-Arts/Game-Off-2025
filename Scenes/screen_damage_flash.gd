extends CanvasLayer

#@export var enemy: PackedScene
#@onready var material: ColorRect = $Screen_flash
#
#var timer = Timer.new()
#
#func _ready() -> void:
	#self.visible = false
	#enemy.hitPlayer.connect(screen_flash)
	#
#
#func screen_flash():
	#self.visible = true
	#var tween = create_tween()
	#tween.tween_property(material, "shader_parameter/intensity", 1.0, 0.1)
	#tween.tween_property(material, "shader_parameter/intensity", 0.0, 0.2)
