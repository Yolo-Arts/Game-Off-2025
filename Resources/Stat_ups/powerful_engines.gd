class_name powerful_engines_stat_up
extends Statup

func apply_upgrade(player: Player):
	player.boost_decay *= 0.8
	player.drift_invulnerability += 0.20
