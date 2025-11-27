extends cannon_ball_upgrade

class_name explosive_shot

func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:

	Cannonball_scene.set_explosive()
	
	return Cannonball_scene
