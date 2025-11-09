extends CanvasLayer

func _ready():
	Globals.player_died.connect(display_scores)

func _on_menu_pressed():
	print("Menu Pressed")



func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Score Labels:
@onready var seconds_score = %secondsScore
@onready var shipwrecked_score = %shipwreckedScore
@onready var bounty_score = %bountyScore
@onready var waves_survived_score = %waves_survivedScore
@onready var bosses_shipwrecked_score = %bosses_shipwreckedScore

func display_scores():
	# Access the score dictionary from the Globals singleton
	var final_score = Globals.score

	# Update each label with the corresponding score value
	# Make sure to convert the integer score to a string using str()
	seconds_score.text = str(final_score["PER_SECOND_SURVIVED"])
	shipwrecked_score.text = str(final_score["ENEMY_SHIPWRECKED"])
	bounty_score.text = str(final_score["BOUNTY_POINT"])
	waves_survived_score.text = str(final_score["WAVES_SURVIVED"])
	bosses_shipwrecked_score.text = str(final_score["BOSSES_SHIPWRECKED"])

	# --- Optional: Calculate and Display a Total Score ---
	# You can loop through the dictionary to sum up all the points
	#var total_score = 0
	#for key in final_score:
		#total_score += final_score[key]
	# If you have a label for the total score, you can set it like this:
	# total_score_label.text = "Total Score: " + str(total_score)
