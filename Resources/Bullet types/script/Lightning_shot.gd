extends cannon_ball_upgrade
class_name lightning_shot

var chain = 3
func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:
	Cannonball_scene.set_lightning(chain)
	return Cannonball_scene
	
func upgrade_self():
	chain += 1
