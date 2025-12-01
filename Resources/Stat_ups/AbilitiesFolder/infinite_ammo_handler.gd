extends Node

func activate_ability(player: Player):
	Signals.infinite_ammo.emit(3.0)
