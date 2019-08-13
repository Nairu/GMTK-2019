extends HBoxContainer

func _on_Slider_value_changed(value):
	var db = clamp(round(20*(log(value*0.01))), -80, 0)
	AudioServer.set_bus_volume_db(0, db)
	$Value.text = str(value)