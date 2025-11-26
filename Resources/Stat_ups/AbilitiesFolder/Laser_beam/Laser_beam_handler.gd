extends Node

var duration = 10.0
func activate_ability(player: Player):
	Signals.laser_beam.emit(duration)
