class_name Statup
extends Resource

@export var image: Texture2D
@export var name: String
@export_multiline var description: String
@export var Weight:  int

@export_enum("Passive", "Ability", "Bullet Type")
var type = "Passive"

@export var is_unique: bool = false

func apply_upgrade(player: Player):
	# applys stat upgrade to player
	pass
	
func apply_cannonBall_upgrade(cannonball: Cannonball):
	pass
