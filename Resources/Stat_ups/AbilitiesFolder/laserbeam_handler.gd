extends Node

var duration = 5.0
func activate_ability(player: Player):
	Signals.laser_beam.emit(duration)
