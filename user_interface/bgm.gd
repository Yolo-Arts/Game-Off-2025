extends HSlider

var bus_bgm: String = "BGM"

var index_bgm : int





func _ready() -> void:
	index_bgm = AudioServer.get_bus_index(bus_bgm)
	value_changed.connect(_on_value_changed_bgm)

	


func _on_value_changed_bgm(value : float) -> void:
	AudioServer.set_bus_volume_db(
		index_bgm,
		linear_to_db(value)
	)
