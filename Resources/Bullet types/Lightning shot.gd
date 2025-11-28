extends cannon_ball_upgrade
class_name lightning_shot

func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:
	Cannonball_scene.set_lightning(3)
	return Cannonball_scene
	
