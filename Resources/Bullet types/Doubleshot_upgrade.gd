extends cannon_ball_upgrade
class_name double_shot

var spread = 20.0

func apply_cannonball_upgrade(Cannonball_scene):
	
	Cannonball_scene.add_cannonball(1, spread)
	
	return Cannonball_scene
	
	
	
