extends Control

var charging : bool

func _process(delta):
	$Score.text = "Score: " + str(Globals.score)
	
	$Shield/ShieldLevels/Shields/Shield1.visible = Globals.shield >= 1
	$Shield/ShieldLevels/Shields/Shield2.visible = Globals.shield >= 2
	
	if (Globals.recharge_shield and not charging):
		charging = true
		$Shield/ShieldRecharge/RechargeTimer.start(1)

func _on_RechargeTimer_timeout():
	if (charging):
		if $Shield/ShieldRecharge/ShieldRecharging.value != 5:
			$Shield/ShieldRecharge/ShieldRecharging.value += 1
		else:
			if Globals.shield != Globals.shield_max:
				$Shield/ShieldRecharge/ShieldRecharging.value = 0
			
		if Globals.shield != Globals.shield_max:
			$Shield/ShieldRecharge/RechargeTimer.start(1)
		else:
			charging = false;
			Globals.recharge_shield = false
			