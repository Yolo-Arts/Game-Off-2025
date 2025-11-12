extends CanvasLayer

func _ready():
	Globals.player_died.connect(display_scores)
	
	animate_stats()

func _on_menu_pressed():
	print("Menu Pressed")

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/isometric_main.tscn")

# Score Labels:
@onready var seconds_score = %secondsScore
@onready var shipwrecked_score = %shipwreckedScore
@onready var bounty_score = %bountyScore
@onready var waves_survived_score = %waves_survivedScore
@onready var bosses_shipwrecked_score = %bosses_shipwreckedScore
@onready var total_score_label = %total_score



@onready var score_categories: VBoxContainer = $Control/Scoreboard/VBoxContainer/Scoreboard/MarginContainer2/CategoriesAndScoresDivider/ScoreCategories



func display_scores():
	var final_score = Globals.score
	seconds_score.text = str(final_score["PER_SECOND_SURVIVED"])
	shipwrecked_score.text = str(final_score["ENEMY_SHIPWRECKED"])
	bounty_score.text = str(final_score["BOUNTY_POINT"])
	waves_survived_score.text = str(final_score["WAVES_SURVIVED"])
	bosses_shipwrecked_score.text = str(final_score["BOSSES_SHIPWRECKED"])

	var total_score = 0
	for key in final_score:
		total_score += final_score[key]
	total_score_label.text = str(total_score)

func animate_stats() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for child in score_categories.get_children():
		tween.tween_property(child, "position:x", 0.0, 0.25).from(-get_viewport().size.x)
		tween.tween_property(child, "modulate:a", 1.0, 0.25).from(0.0)
