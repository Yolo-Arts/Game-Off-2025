# day_night_cycle.gd
extends Node

const DAY_DURATION_IN_SECONDS: float = 120.0

const NOON_COLOR: Color = Color(1.0, 1.0, 0.95)
const NIGHT_COLOR: Color = Color(0.375, 0.375, 0.375, 1.0)


@onready var canvas_modulate: CanvasModulate = %TimeCycle
@onready var player_light: PointLight2D = get_tree().get_first_node_in_group("player_light")


var time_of_day: float = 0.0
var current_period: String = "Day"

var color_tween: Tween = null
var light_tween: Tween = null



func _ready() -> void:
	var day_or_night = randi_range(0, 1)
	match day_or_night:
		0:
			time_of_day = 0.0
			current_period = "Day"
			canvas_modulate.color = NOON_COLOR
			if player_light:
				player_light.enabled = false
				player_light.energy = 0.0
		1:
			time_of_day = 0.5
			current_period = "Night"
			canvas_modulate.color = NIGHT_COLOR
			if player_light:
				player_light.enabled = true
				player_light.energy = 0.61

func _process(delta: float) -> void:
	time_of_day += delta / DAY_DURATION_IN_SECONDS
	if time_of_day >= 1.0:
		time_of_day -= 1.0

	if time_of_day >= 0.0 and time_of_day <= 0.5 and current_period != "Day":
		current_period = "Day"
		_transition_to_color(NOON_COLOR)
		
		if player_light:
			_player_light_fade_out()
	
	elif time_of_day > 0.5 and time_of_day <= 1.0 and current_period != "Night":
		current_period = "Night"
		_transition_to_color(NIGHT_COLOR)
		if player_light:
			_player_light_fade_in()


func _transition_to_color(new_color: Color) -> void:
	if color_tween:
		color_tween.kill()
	
	color_tween = create_tween()
	color_tween.tween_property(canvas_modulate, "color", new_color, 10)

func _player_light_fade_in() -> void:
	if not player_light:
		return
	
	if light_tween:
		light_tween.kill()
	
	player_light.enabled = true
	player_light.energy = 0.0
	
	light_tween = create_tween()
	light_tween.tween_property(player_light, "energy", 0.61, 10.0)

func _player_light_fade_out() -> void:
	if not player_light:
		return
		
	if light_tween:
		light_tween.kill()
	
	light_tween = create_tween()
	light_tween.tween_property(player_light, "energy", 0.0, 10.0)
	light_tween.tween_callback(func(): 
		if player_light:
			player_light.enabled = false)
