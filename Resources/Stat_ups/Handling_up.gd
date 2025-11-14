class_name Handling_stat_up
extends Statup

func apply_upgrade(player: Player):
	player.max_turn_speed += 1.0
	player.turn_acceleration += 0.05
	
