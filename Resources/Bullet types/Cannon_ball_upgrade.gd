extends Statup
class_name cannon_ball_upgrade

@export_enum("passive", "direction_altering")
var cannonball_upgrade_type = "passive"

func apply_cannonball_upgrade(Cannonball_scene: PackedScene) -> PackedScene:
	
	return Cannonball_scene
