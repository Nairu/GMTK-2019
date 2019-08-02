extends KinematicBody2D

export (float) var acceleration_straight = 10
export (float) var acceleration_angle = 7.77
export (float) var top_speed = 500

var motion = Vector2()
var currentDirection = 0
var current_speed = 100

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		currentDirection = (currentDirection + 45) % 360
		$Sprite.rotation_degrees = currentDirection
		current_speed = 100
		
	if currentDirection == 0:
			motion = Vector2(0,-current_speed)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 45:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 90:
			motion = Vector2(current_speed, 0)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 135:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 180:
			motion = Vector2(0, current_speed)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 225:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
	elif currentDirection == 270:
			motion = Vector2(-current_speed, 0)
			current_speed = min(current_speed + acceleration_straight, top_speed)
	else:
			motion = Vector2(current_speed * cos(deg2rad(currentDirection-90)), current_speed * sin(deg2rad(currentDirection-90)))
			current_speed = min(current_speed + acceleration_straight, top_speed)
		
	move_and_slide(motion)
	pass