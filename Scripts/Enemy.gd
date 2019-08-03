extends Area2D

signal player_hit

export(bool) var is_enemy = true

var player_node = null
var player_dir = Vector2()
var screen_size
var screen_buffer = 20

func _ready():
	screen_size = get_viewport_rect().size
	self.connect("area_entered", self, "_on_Ship_body_entered") 

func _physics_process(delta):
	
	if player_node == null:
		player_node = get_node("/root/BaseNode/ShipNode")
		player_dir = (player_node.get_transform().origin - get_transform().origin).normalized()
		look_at(player_node.get_transform().origin)
		
	#move_and_slide(player_dir * 200)
	position.x = lerp(position.x, position.x + (player_dir.x * 200), delta)
	position.y = lerp(position.y, position.y + (player_dir.y * 200), delta)
	
	if position.x > screen_size.x + screen_buffer or position.x < -screen_buffer or position.y > screen_size.y + screen_buffer or position.y < -screen_buffer:
		queue_free()

func _on_Ship_body_entered(body):
	if (not body.get("is_player") == null):
		emit_signal("player_hit")
		body.was_hit = true

#func _process(delta):
#	if is_colliding():
#		var collider = get_collider()
#
#export (Vector2) var acceleration_straight = 10
#export (float) var acceleration_angle = 7.77
#export (float) var top_speed = 500
#
#var motion = Vector2()
#var currentDirection = 0
#var current_speed = 100
#
#func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		currentDirection = (currentDirection + 45) % 360
#		$Sprite.rotation_degrees = currentDirection
#		current_speed = 100
#
#	if currentDirection == 0:
#			motion = Vector2(0,-current_speed)
#			current_speed = min(current_speed + acceleration_straight, top_speed)
#	elif currentDirection == 45:
#			motion = Vector2(sqrt(2*(pow(current_speed, 2))), -sqrt(2*(pow(current_speed, 2))))
#			current_speed = min(current_speed + acceleration_angle, top_speed)
#	elif currentDirection == 90:
#			motion = Vector2(current_speed, 0)
#			current_speed = min(current_speed + acceleration_straight, top_speed)
#	elif currentDirection == 135:
#			motion = Vector2(sqrt(2*(pow(current_speed, 2))), sqrt(2*(pow(current_speed, 2))))
#			current_speed = min(current_speed + acceleration_angle, top_speed)
#	elif currentDirection == 180:
#			motion = Vector2(0, current_speed)
#			current_speed = min(current_speed + acceleration_straight, top_speed)
#	elif currentDirection == 225:
#			motion = Vector2(-sqrt(2*(pow(current_speed, 2))), sqrt(2*(pow(current_speed, 2))))
#			current_speed = min(current_speed + acceleration_angle, top_speed)
#	elif currentDirection == 270:
#			motion = Vector2(-current_speed, 0)
#			current_speed = min(current_speed + acceleration_straight, top_speed)
#	else:
#			motion = Vector2(-sqrt(2*(pow(current_speed, 2))), -sqrt(2*(pow(current_speed, 2))))
#			current_speed = min(current_speed + acceleration_angle, top_speed)
#
#	move_and_slide(motion)
#	pass