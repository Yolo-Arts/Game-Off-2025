extends Label

var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_score(points_scored):
	score += points_scored
	text = "Score: %s" % score
