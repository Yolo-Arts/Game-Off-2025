extends Statup
class_name cannon_ball_upgrade

@export_enum("passive", "direction_altering")
var cannonball_upgrade_type = "passive"

var packed_scene = PackedScene.new()
var cannonballs_array = []

func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:
	
	return Cannonball_scene
