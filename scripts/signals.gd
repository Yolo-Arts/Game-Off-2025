extends Node

# emit with 2 arguments: timescale and duration
# timescale is like YouTube playback speed.
# Duration is how long the freeze is for
signal start_hitStop
signal collect_all_exp(player:Player)

signal shockwave_fired
signal infinite_ammo
signal time_freeze(duration: float)
signal time_freeze_disable
signal ghost_ship(duration: float)
signal magnetic_balls(duration: float)
signal laser_beam

signal repair_collected
