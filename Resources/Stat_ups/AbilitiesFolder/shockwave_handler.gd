extends Node


func activate_ability(player: Player):
	Signals.shockwave_fired.emit()
