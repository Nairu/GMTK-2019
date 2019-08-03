extends Control

export(int) var score
export(int) var health

func set_score(value):
	print("We've got here at least")
	score = value
	print(value)
	print(score)
	$Label.text = "Score: " + str(score)