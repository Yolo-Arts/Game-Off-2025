extends cannon_ball_upgrade
class_name double_shot

var spread = 20.0
var added_cannonballs = 1

func apply_cannonball_upgrade(Cannonball_scene):
	
	Cannonball_scene.add_cannonball(added_cannonballs, spread)
	
	return Cannonball_scene
	
func upgrade_self():
	added_cannonballs += 1
