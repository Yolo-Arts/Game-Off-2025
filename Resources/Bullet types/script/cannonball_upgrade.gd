extends Statup
class_name cannon_ball_upgrade

@export_enum("passive", "direction_altering", "number_altering")
var cannonball_upgrade_type = "passive"

var cannonballs_array = []

func _ready():
	type = "Bullet Type"

func apply_cannonball_upgrade(Cannonball_scene: Cannonball_shot) -> Cannonball_shot:
	
	return Cannonball_scene

func upgrade_self():
	pass
