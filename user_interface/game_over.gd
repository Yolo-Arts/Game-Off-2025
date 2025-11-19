extends CanvasLayer

# Score Labels:
@onready var seconds_score = %secondsScore
@onready var shipwrecked_score = %shipwreckedScore
@onready var bounty_score = %bountyScore
@onready var waves_survived_score = %waves_survivedScore
@onready var bosses_shipwrecked_score = %bosses_shipwreckedScore

@onready var score_categories: VBoxContainer = %ScoreCategories
@onready var score_points = %ScorePoints
@onready var final_score_label = %FinalScoreLabel
@onready var total_score_label = %total_score

@onready var shaker = $Shaker
@onready var animation_player = $AnimationPlayer


func _ready():
	Globals.player_died.connect(display_scores)
	
	
	# FIXME Variables for testing score tween. Comment them out later
	#Globals.score["PER_SECOND_SURVIVED"] = 500
	

func _on_restart_pressed():
	animation_player.play("close-transition")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/isometric_main.tscn")



var total_score = 0
func display_scores():
	var final_score = Globals.score
	seconds_score.text = str(final_score["PER_SECOND_SURVIVED"])
	shipwrecked_score.text = str(final_score["ENEMY_SHIPWRECKED"])
	bounty_score.text = str(final_score["BOUNTY_POINT"])
	waves_survived_score.text = str(final_score["WAVES_SURVIVED"])
	bosses_shipwrecked_score.text = str(final_score["BOSSES_SHIPWRECKED"])

	for key in final_score:
		total_score += final_score[key]
	total_score_label.text = str(total_score)
	
	hide_stats()
	animate_stats()

func hide_stats() -> void:
	for child in score_categories.get_children():
		child.self_modulate.a = 0.0
	for child in score_points.get_children():
		child.self_modulate.a = 0.0
	final_score_label.self_modulate.a = 0.0
	total_score_label.self_modulate.a = 0.0
	$Control/Scoreboard/VBoxContainer/Scoreboard/RestartMargin.modulate.a = 0.0

func animate_stats() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for child in score_categories.get_children():
		tween.tween_property(child, "position:x", 0.0, 0.25).from(-get_viewport().size.x)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.25).from(0.0)
	
	for i in range(score_points.get_child_count()):
		var child = score_points.get_child(i)
		var key = Globals.score.keys()[i]
		tween.tween_method(set_label_number.bind(child), 0, Globals.score[key], 0.5)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.05).from(0.0)
		tween.parallel().tween_callback(screen_shake.bind(0.4, 20, 10))
		tween.parallel().tween_callback(shaker.start.bind(0.25))
		tween.tween_interval(0.25)
	
	tween.tween_interval(0.25)
	
	tween.tween_property(final_score_label, "position:x", 80.0, 0.3).from(-get_viewport().size.x)
	tween.parallel().tween_property(final_score_label, "self_modulate:a", 1.0, 0.25).from(0.0)
	
	tween.tween_method(set_label_number.bind(total_score_label), 0, total_score, 1.0)
	tween.parallel().tween_property(total_score_label, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(screen_shake.bind(1.0, 30, 10))
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	
	tween.tween_interval(1.0)
	
	tween.tween_property($Control/Scoreboard/VBoxContainer/Scoreboard/RestartMargin, "position:y", 610, 0.3).from(get_viewport().size.y)
	tween.parallel().tween_property($Control/Scoreboard/VBoxContainer/Scoreboard/RestartMargin, "modulate:a", 1.0, 0.1).from(0.0)
	#tween.tween_callback($Control/Scoreboard/VBoxContainer/Scoreboard/RestartMargin/Restart.grab_focus)

func set_label_number(number: int, label: Label) -> void:
	label.set_text(str(number))

func screen_shake(duration: float, frequency: float, amplitude: float) -> void:
	Globals.camera.shake(duration, frequency, amplitude)
