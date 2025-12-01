extends Ability
class_name Laser_beam

func _init() -> void:
	name = "Laser"
	description = "fire a massive laserbeam from the front of the ship"
	#Weight = 400
	type = "Ability"
	cooldown = 20.0
