extends VBoxContainer

func _on_SaveButton_pressed():
	var music_db = clamp(round(20*(log($MusicVolumeSlider/Slider.value*0.01))), -80, 0)
	Globals.music_volume = music_db	
	AudioServer.set_bus_volume_db(0, Globals.music_volume)	
	
	var sfx_db = clamp(round(20*(log($SFXVolumeSlider/Slider.value*0.01))), -80, 0)
	Globals.sfx_volume = sfx_db
	AudioServer.set_bus_volume_db(1, Globals.sfx_volume)
