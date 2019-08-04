extends Control

export (String, FILE, "*.tscn") var play_scene

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene(play_scene)