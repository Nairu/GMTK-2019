extends Area2D

var direction = Vector2(0, 1)
var area = null

signal enemy_hit

var screen_size
export(PackedScene) var player_node

func _ready():
	connect("area_entered", self, "_on_Bullet_body_entered")
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	#move_and_slide(direction)
	position.x = lerp(position.x, position.x + direction.x, delta)
	position.y = lerp(position.y, position.y + direction.y, delta)
	
	var player_viewable_bounds
	player_viewable_bounds = Rect2(player_node.position.x - screen_size.x/2, 
								   player_node.position.y - screen_size.y/2,
								   screen_size.x,
								   screen_size.y)
								
	if not player_viewable_bounds.has_point(position):
		queue_free()
	
func _on_Bullet_body_entered(body):
	if (not body.get("is_enemy") == null):
		body.queue_free()
		queue_free()
		emit_signal("enemy_hit", body.position)
	elif (not body.get("is_asteroid") == null):
		body.handle_collision()
		queue_free()