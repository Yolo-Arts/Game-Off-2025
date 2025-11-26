class_name Bullet_type
extends Statup

var left_cannon_direction
var right_cannon_direction

func apply_cannonball_upgrades(Cannonball_scene: PackedScene) -> PackedScene:
	if not Globals.active_cannonball_upgrades.is_empty():
		for upgrade in Globals.active_cannonball_upgrades:
			Cannonball_scene = upgrade.apply_cannonball_upgrade(Cannonball_scene)
	
	return Cannonball_scene
func _ready():
	pass
	
func shoot(cannonball: PackedScene, player: Player, isometric = false, scale = 1.0):
	
	pass

func iso_shoot(cannonball: PackedScene, player: Player):
	
	pass

func spawn_cannon_particles(pos: Vector2, normal: Vector2, player: Player):
	
	pass
