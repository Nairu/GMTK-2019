extends Control

signal _on_PlayButton_pressed;
signal _on_RulesButton_pressed;
signal _on_CreditsButton_pressed;
signal _on_QuitButton_pressed;

export (String, FILE, "*.tscn") var play_scene
export (String, FILE, "*.tscn") var rules_scene
export (String, FILE, "*.tscn") var credits_scene

onready var play: Button = $ButtonContainer/PlayButton
onready var rules: Button = $ButtonContainer/RulesButton
onready var credits: Button = $ButtonContainer/CreditsButton
onready var quit: Button = $ButtonContainer/QuitButton

func _ready():
	play.connect("pressed", self, "_on_PlayButton_pressed")
	rules.connect("pressed", self, "_on_RulesButton_pressed")
	credits.connect("pressed", self, "_on_CreditsButton_pressed")
	quit.connect("pressed", self, "_on_QuitButton_pressed")
	
	play.grab_focus()
		

func _on_PlayButton_pressed():
	get_tree().change_scene(play_scene)
	
func _on_RulesButton_pressed():
	get_tree().change_scene(rules_scene)
	pass
	
func _on_CreditsButton_pressed():
	get_tree().change_scene(credits_scene)
	pass
	
func _on_QuitButton_pressed():
	get_tree().quit()