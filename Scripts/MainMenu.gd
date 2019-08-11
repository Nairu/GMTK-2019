extends Control

var scene_path_to_load : String

func _ready():
	$Menu/Body/Buttons/PlayButton.grab_focus()
	
	for button in $Menu/Body/Buttons.get_children():
		if "scene_to_load" in button:
			button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		

func _on_Button_pressed(scene_to_load : String) -> void:
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
	
func _on_FadeIn_fade_finished() -> void:
	get_tree().change_scene(scene_path_to_load)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
