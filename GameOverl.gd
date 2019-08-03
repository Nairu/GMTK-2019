extends Control

export (String, FILE, "*.tscn") var game_scene

func _ready():
	$Label.text = "SCORE: " + str(Globals.score) + "\n\nPRESS SPACE TO\nCONTINUE"
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		Globals.score = 0
		get_tree().change_scene(game_scene)