extends Ability
class_name TimeFreezeAbility

func _init() -> void:
	name = "Time Freeze"
	description = "All enemy sips are frozen in time for 5 seconds!"
	Weight = 400
	type = "Ability"
	cooldown = 20.0
