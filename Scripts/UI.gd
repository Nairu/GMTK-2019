extends Control

export(int) var score
export(int) var health

func set_score(value):
	score = value
	$Label.text = "Score: " + str(score)