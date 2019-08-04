extends Area2D

var direction = Vector2(0, 1)
var area = null

signal enemy_hit

export(PackedScene) var explosion

var screen_size
export(PackedScene) var player_node

var timer_bomb_delay = null

func set_bomb_delay():
	timer_bomb_delay = Timer.new()
	add_child(timer_bomb_delay)
	timer_bomb_delay.connect("timeout", self, "_on_bomb_timeout")
	timer_bomb_delay.set_wait_time(2)
	timer_bomb_delay.set_one_shot(false)

func _ready():
	self.set_bomb_delay()
	
	self.connect("area_entered", self, "_on_bomb_body_entered")
	screen_size = get_viewport_rect().size
	$BombAnimation.play("default")
	timer_bomb_delay.start()
	
	if player_node == null:
		player_node = get_node("/root/BaseNode/Player")

func _physics_process(delta):
	#move_and_slide(direction)
	position.x = lerp(position.x, position.x + direction.x, delta)
	position.y = lerp(position.y, position.y + direction.y, delta)
	
	var player_viewable_bounds
	player_viewable_bounds = Rect2(player_node.position.x - screen_size.x / 2, 
								   player_node.position.y - screen_size.y / 2,
								   screen_size.x,
								   screen_size.y)
								
	if not player_viewable_bounds.has_point(position):
		queue_free()

func _on_bomb_timeout():
	var explosion_instance	= explosion.instance()
	if not player_node == null:
		player_node.shake(0.3,15,20,1)
		
	explosion_instance.cosmetic = true
	explosion_instance.position = position
	explosion_instance.rotation_degrees = randf()*360
	get_parent().add_child(explosion_instance)
	queue_free()

func _on_bomb_body_entered(body):
	if (not body.get("is_enemy") == null):
		body.queue_free()
		queue_free()
		emit_signal("enemy_hit", body.position)
	elif (not body.get("is_asteroid") == null):
		body.handle_collision()
		queue_free()