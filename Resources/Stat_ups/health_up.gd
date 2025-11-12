class_name Health_stat_up
extends Statup

func apply_upgrade(player: Player):
	player.player_max_health += 50
	player.health += 50
	
