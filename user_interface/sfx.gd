extends HSlider

var bus_sfx: String = "SFX"
var bus_reload: String = "Bullet_Reload"
var bus_hb: String = "HeartBeat"
var bus_horn: String = "WarHorn"


var index_sfx : int
var index_reload: int
var index_hb: int
var index_horn: int



func _ready() -> void:
	index_sfx = AudioServer.get_bus_index(bus_sfx)
	index_reload = AudioServer.get_bus_index(bus_reload)
	index_hb = AudioServer.get_bus_index(bus_hb)
	index_horn = AudioServer.get_bus_index(bus_horn)
	value_changed.connect(_on_value_changed_sfx)
	


func _on_value_changed_sfx(value: float) -> void:
	AudioServer.set_bus_volume_db(
		index_sfx,
		linear_to_db(value)
	)
	AudioServer.set_bus_volume_db(
		index_reload,
		linear_to_db(value)
	)
	AudioServer.set_bus_volume_db(
		index_hb,
		linear_to_db(value)
	)
	AudioServer.set_bus_volume_db(
		index_horn,
		linear_to_db(value)
	)
