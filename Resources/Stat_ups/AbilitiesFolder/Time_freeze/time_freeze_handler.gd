extends Node

var duration = 5.0

func activate_ability(player: Player):
	Signals.time_freeze.emit(duration)
