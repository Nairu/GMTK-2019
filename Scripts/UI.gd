extends Control
	
func _process(delta):
	$Score.text = "Score: " + str(Globals.score)
	$Shield.text = "Shield Health: " + str(Globals.shield)
	
	#if Globals.recharge_shield:
		# 270
		#print("Charge!")
		#$ShieldCharge.