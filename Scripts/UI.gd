extends Control

func _ready():
	$ShieldCharger.connect("value_changed", self, "_on_update_progress")

func _process(delta):
	$Score.text = "Score: " + str(Globals.score)
	$Shield.text = "Shield Health: " + str(Globals.shield)
	
	if Globals.recharge_shield:
		print("charing")
		$ShieldCharger.value = 0
		
	if $ShieldCharger.value < 5:
		pass
		
func _on_update_progress(value):
	pass
	