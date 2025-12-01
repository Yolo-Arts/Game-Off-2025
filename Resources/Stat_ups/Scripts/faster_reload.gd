extends Statup
class_name faster_reload

func apply_upgrade(player: Player):
	player.shoot_cooldown.wait_time *= 0.85
	if player.shoot_cooldown.wait_time <= 0.1:
		player.shoot_cooldown.wait_time = 0.1
