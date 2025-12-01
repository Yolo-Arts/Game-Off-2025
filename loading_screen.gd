extends Control

var progress = []
var sceneName
var scene_load_status =  0
@onready var loading_percent: Label = $LoadingPercent

func _ready() -> void:
	get_tree().paused = false
	sceneName = "res://Scenes/isometric_main.tscn"
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	loading_percent.text = "Loading..."
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
		
