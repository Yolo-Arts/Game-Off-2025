extends cannon_ball_upgrade
class_name double_shot

var spread = 20.0
func apply_cannonball_upgrade(cannon_instance: Cannonball):
	var cannon_instance2 = cannon_instance.duplicate()
	cannon_instance.position += Vector2(0, spread)
	cannon_instance2.position -= Vector2(0, spread)
