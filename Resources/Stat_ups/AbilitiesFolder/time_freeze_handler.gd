extends Node

var duration = 10.0

func activate_ability(player: Player):
	Signals.time_freeze.emit(duration)
