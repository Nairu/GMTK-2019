extends Area2D

signal enemy_hit

enum Weapon_Type { NONE, SINGLE, SPREAD, SHIELD }
export (Weapon_Type) var weapon_type

export(PackedScene) var bullet = load("res://Objects/Bullet.tscn")
export(bool) var is_player = true
export(bool) var was_hit = false

export (float) var acceleration_straight = 10
export (float) var acceleration_slow = -10
export (float) var top_speed = 350
export (float) var min_speed = 100
export (float) var rotation_speed = 10.0

export (bool) var use_slowdown = false
export (float) var slow_factor = 1.1
export (int) var slowdown_offset = 25

export (String, FILE, "*.tscn") var game_over_scene

export (Vector2) var motion = Vector2()
var currentDirection = 0
var current_speed = 100
var shield_hits = 2
var impenetrable_shield = false

var timer = null
var timer_weapon_turnoff = null

func shake(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude, priority)

func set_shield():
	if impenetrable_shield:
		return
	
	shield_hits = 2
	var target_mod = $ActiveShield.modulate;
	$DeactiveShield.visible = false
	$ActiveShield.visible = true
	$ActiveShield.play("default")
	$ActiveShield.modulate.a = 0
	target_mod.a = 1
	$ShieldTween.interpolate_property($ActiveShield, "modulate", $ActiveShield.modulate, target_mod, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	$ShieldTween.repeat = false
	$ShieldTween.start()
	
func lose_shield():
	$ActiveShield.visible = false
	$DeactiveShield.visible = true
	$DeactiveShield.frame = 0
	$DeactiveShield.play("default")
	$ShieldTimer.start(5)

func change_weapon(weapon_type, turnoff, turnoff_time=0):
	self.weapon_type = weapon_type
	if turnoff:
		timer_weapon_turnoff.set_wait_time(turnoff_time)
		timer_weapon_turnoff.set_one_shot(true)
		timer_weapon_turnoff.start()
	
	if self.weapon_type == Weapon_Type.SPREAD:
		timer.set_wait_time(0.5)
	elif self.weapon_type == Weapon_Type.NONE:
		timer.set_wait_time(0)
	elif self.weapon_type == Weapon_Type.SHIELD:
		timer.set_wait_time(0)
		set_shield()
		impenetrable_shield = true
		var scale = $ActiveShield.scale
		scale *= 2
		$ShieldCollision.disabled = false
		$ShieldTween.interpolate_property($ActiveShield, "scale", $ActiveShield.scale, scale, 1, Tween.TRANS_SINE, Tween.EASE_IN)
		$ShieldTween.start()
	else:
		timer.set_wait_time(0.25)

func _on_Timer_weapon_timeout():
	if weapon_type == Weapon_Type.SHIELD:
		impenetrable_shield = false
		$ShieldCollision.disabled = true
		$ShieldTween.interpolate_property($ActiveShield, "scale", $ActiveShield.scale, Vector2(1,1), 1, Tween.TRANS_SINE, Tween.EASE_IN)
		$ShieldTween.start()
		set_shield()
		
	change_weapon(Weapon_Type.SINGLE, false)

func _ready():
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(0.25)
	timer.set_one_shot(false)
	timer.start()
	
	timer_weapon_turnoff = Timer.new()
	add_child(timer_weapon_turnoff)
	timer_weapon_turnoff.connect("timeout", self, "_on_Timer_weapon_timeout")
	
	set_shield()
	
	$ShieldTimer.connect("timeout", self, "set_shield")

func _on_Timer_timeout():
	
	if weapon_type == Weapon_Type.SINGLE:	
		# create a bullet.
		var bullet_instance = bullet.instance()
		bullet_instance.set_name("Bullet")
		bullet_instance.direction = Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)*300
		bullet_instance.position = get_position() + Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)
		bullet_instance.connect("enemy_hit", self, "_on_enemy_hit")
		bullet_instance.player_node = self
		get_parent().add_child(bullet_instance)
	elif weapon_type == Weapon_Type.SPREAD:
		for idx in range(3):
			var bullet_instance = bullet.instance()
			bullet_instance.set_name("Bullet")
			bullet_instance.position = get_position() + Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)
			bullet_instance.player_node = self
						
			if idx == 0:
				bullet_instance.direction = Vector2(cos(deg2rad(currentDirection-75))*2, sin(deg2rad(currentDirection-75))*2)*300
			elif idx == 1:
				bullet_instance.direction = Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)*300
			elif idx == 2:
				bullet_instance.direction = Vector2(cos(deg2rad(currentDirection-105))*2, sin(deg2rad(currentDirection-105))*2)*300
			bullet_instance.connect("enemy_hit", self, "_on_enemy_hit")
			get_parent().add_child(bullet_instance)
		pass

func _on_enemy_hit(position):
	emit_signal("enemy_hit", position)

func _process(delta):
	if was_hit:
		was_hit = false
		if impenetrable_shield:
			return
		
		if shield_hits > 1:
			shake()
			shield_hits -= 1
		elif shield_hits == 1:
			shield_hits -= 1
			lose_shield()
		else:
			# Soon we will go to the game over screen, but for now just keep it as a restart.
			get_tree().change_scene(game_over_scene)

var length = 0
func _physics_process(delta):
	
	if Input.is_action_just_released("ui_accept"):
		currentDirection = (currentDirection + 45)
		timer.start()
		_on_Timer_timeout()
		length = 0		
		#117600 - cYCLONE1370
	if not $Sprite.rotation_degrees == currentDirection:
		$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, (360 if currentDirection == 0 else currentDirection), delta*rotation_speed)
		$CollisionShape2D.rotation_degrees = currentDirection
		
	if use_slowdown:
		if Input.is_action_pressed("ui_accept"):
			if length > slowdown_offset:
				current_speed = current_speed + acceleration_slow * slow_factor
				current_speed = max(current_speed, min_speed)
			
			length = length + 1
		
	if currentDirection % 360 == 0:
			motion = Vector2(0,-current_speed)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 45:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 90:
			motion = Vector2(current_speed, 0)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 135:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 180:
			motion = Vector2(0, current_speed)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 225:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection % 360 == 270:
			motion = Vector2(-current_speed, 0)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	else:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
		
	#move_and_slide(motion)
	position.x = lerp(position.x, position.x + motion.x, delta)
	position.y = lerp(position.y, position.y + motion.y, delta)
	
	pass