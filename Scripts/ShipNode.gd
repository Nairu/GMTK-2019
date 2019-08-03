extends Area2D

signal enemy_hit

export(PackedScene) var bullet = load("res://Objects/Bullet.tscn")
export(bool) var is_player = true
export(bool) var was_hit = false

export (float) var acceleration_straight = 10
export (float) var acceleration_slow = -10
export (float) var top_speed = 350
export (float) var min_speed = 100
export (float) var rotation_speed = 10.0
export (float) var slow_factor = 1.1

export (String, FILE, "*.tscn") var game_over_scene

var motion = Vector2()
var currentDirection = 0
var current_speed = 100

var timer = null

func _ready():
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(0.25)
	timer.set_one_shot(false)
	timer.start()

func _on_Timer_timeout():
	# create a bullet.
	var bullet_instance = bullet.instance()
	bullet_instance.set_name("Bullet")
	bullet_instance.direction = Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)*300
	bullet_instance.position = get_position() + Vector2(cos(deg2rad(currentDirection-90))*2, sin(deg2rad(currentDirection-90))*2)
	bullet_instance.connect("enemy_hit", self, "_on_enemy_hit")
	get_parent().add_child(bullet_instance)

func _on_enemy_hit(position):
	emit_signal("enemy_hit", position)

func _process(delta):
	if was_hit:
		# Soon we will go to the game over screen, but for now just keep it as a restart.
		get_tree().change_scene(game_over_scene)

var length = 0
func _physics_process(delta):
	
	if Input.is_action_just_released("ui_accept"):
		currentDirection = (currentDirection + 45)
		length = 0
		
	if not $Sprite.rotation_degrees == currentDirection:
		$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, (360 if currentDirection == 0 else currentDirection), delta*rotation_speed)
		
	if Input.is_action_pressed("ui_accept"):
		current_speed = current_speed + acceleration_slow * slow_factor
		current_speed = max(current_speed, min_speed)	
		
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