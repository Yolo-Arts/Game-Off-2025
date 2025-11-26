extends Area2D

var base_damage = 20
func _on_body_entered(body: Node2D) -> void:
		if body.has_method("take_damage"):
			body.take_damage(base_damage)
