class_name Shot_size_stat_up
extends Statup

func apply_upgrade(player: Player):
	player.cannonball_scale += 0.20
	player.damage += 2
