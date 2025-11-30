extends cannon_ball_upgrade
class_name explosive_shot

var explosion_scale = 1.0

func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:

	Cannonball_scene.set_explosive()
	Cannonball_scene.set_explosion_scale(Vector2(explosion_scale, explosion_scale))
	
	return Cannonball_scene

func upgrade_self():
	explosion_scale += 0.4
