extends Area2D

signal player_hit
signal enemy_died

enum Enemy_Type { TRIDENT, FOLLOWER, CIRCLER, BOMBER }
export(Enemy_Type) var type

export(bool) var is_enemy = true
export(PackedScene) var explosion_small
export(PackedScene) var explosion

var player_node = null
var player_dir = Vector2()
var screen_size
var screen_buffer = 20
var animating = true

var spawn_position = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	self.connect("area_entered", self, "_on_Ship_body_entered") 
	self.connect("area_exited", self, "_on_Ship_body_exited")
	# Do an initial entry animation and then fly on.
	$Sprite.visible = false
	$Wormhole.modulate.a = 0	
    
func _process(delta):
	$Wormhole.modulate.a = min($Wormhole.modulate.a + 0.01, 1)
	$Wormhole.rotation_degrees = $Wormhole.rotation_degrees + 1
	$Wormhole.scale.x = lerp($Wormhole.scale.x, 3, 0.01)
	$Wormhole.scale.y = lerp($Wormhole.scale.y, 3, 0.01)
	
	if $Wormhole.modulate.a == 1:
		spawn_position = position
		animating = false		
		$Sprite.visible = true
	    
func _physics_process(delta):
	if animating:
		return
		
	if player_node == null:
		player_node = get_node("/root/BaseNode/Player")
	
	if $Wormhole.modulate.a > 0:
		$Wormhole.modulate.a = $Wormhole.modulate.a - 0.2
	else:
		$Wormhole.visible = false
	
	var direction = Vector2()
	var speed = 0.0
	
	var movement
	if type == Enemy_Type.TRIDENT:
		movement = _move_trident()
	elif type == Enemy_Type.FOLLOWER:
		movement = _move_follower()
	elif type == Enemy_Type.BOMBER:
		movement = _move_bomber()
	
	direction = movement[0]
	speed = movement[1]
		
	#move_and_slide(player_dir * 200)
	position.x = lerp(position.x, position.x + (direction.x * speed), delta)
	position.y = lerp(position.y, position.y + (direction.y * speed), delta)

var trident_dir = null
func _move_trident():
	if trident_dir == null:
		trident_dir = (player_node.get_transform().origin - get_transform().origin).normalized()
		look_at(player_node.get_transform().origin)
	return [trident_dir, 200]
	
func _move_follower():
	var player_dir = (player_node.get_transform().origin - get_transform().origin).normalized()
#	player_dir.x = max(min(player_dir.x, 0.3), -0.3)
#	player_dir.y = max(min(player_dir.y, 0.3), -0.3)
	#look_at(player_node.get_transform().origin)
	
	var m = player_node.get_transform().origin
	var aim_speed = deg2rad(2)
	if get_angle_to(m) > 0:
		rotation = rotation + aim_speed
	else:
		rotation = rotation - aim_speed	
		 
	player_dir = Vector2(cos(rotation), sin(rotation))
	
	return [player_dir + steering_offset, 200]
	
var last_direction = null
func _move_bomber():
	var distance = get_transform().origin.distance_to(player_node.get_transform().origin)
	var dir = (player_node.get_transform().origin - get_transform().origin).normalized()
	
	if distance < 75:
		var explosion_instance = explosion.instance()
		explosion_instance.cosmetic = false
		explosion_instance.position = position
		explosion_instance.rotation_degrees = randf()*360
		get_parent().add_child(explosion_instance)		
		queue_free()
		return [Vector2(0,0), 0]
		
	elif distance < 250:
		last_direction = null
		$Trail2.visible = true
		$Trail3.visible = true
		var movement = _move_follower()
		movement[1] = 250
		return movement
	else:
		$Trail2.visible = false
		$Trail3.visible = false
		if last_direction == null:
			last_direction = _move_follower()[0]
		return [last_direction, 150]

var steering_offset = Vector2(0,0)

func die(reward_player=true):
	dying = true
	var explosion_instance
	if type == Enemy_Type.BOMBER:
		explosion_instance = explosion.instance()
		if not player_node == null:
			player_node.shake(0.3,15,20,1)
	else:
		explosion_instance = explosion_small.instance()
		if not player_node == null:
			player_node.shake()
		
	explosion_instance.cosmetic = true
	explosion_instance.position = position
	explosion_instance.rotation_degrees = randf()*360
	get_parent().add_child(explosion_instance)
	emit_signal("enemy_died", position, reward_player)
	queue_free()

var dying = false
func _on_Ship_body_entered(body):
	if dying:
		return
		
	if not body.get("is_player") == null:
		body.was_hit = true
		die(true)
	elif not body.get("is_enemy") == null:
		# PUSH OURSELVES AWAY
		var target_pos = (body.position - position).normalized()
		steering_offset = Vector2(target_pos.x + int(2*randf()-1), -target_pos.y + int(2*randf()-1))	
	elif not body.get("is_asteroid") == null:
		die(false)
	elif not body.get("is_explosion") == null:
		die(true)
		
func _on_Ship_body_exited(body):
	if not body.get("is_enemy") == null:
		steering_offset = Vector2(0,0)