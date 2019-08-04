extends Control

export (String, FILE, "*.tscn") var game_scene

var can_press = false

func _ready():
	$Label.text = "SCORE: " + str(Globals.score) + "\n\nPRESS SPACE TO\nCONTINUE"
	$Timer.connect("timeout", self, "_timeout")
	
func _timeout():
	can_press = true
	   
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and can_press:
		Globals.score = 0
		get_tree().change_scene(game_scene)