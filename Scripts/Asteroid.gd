extends Area2D

signal spawn_children

export(float) var min_speed = 1
export(float) var max_speed = 5
export(float) var min_rotation = 5
export(float) var max_rotation = 10

var rotate_speed = 10
var direction = Vector2()
var travel_speed = 5
var is_asteroid = true
export(int) var asteroid_size = 0

func _ready():
	rotate_speed = rand_range(min_rotation, max_rotation)
	direction = Vector2(randf()*2-1, randf()*2-1)
	travel_speed = rand_range(min_speed, max_speed)
	connect("area_entered", self, "_on_Asteroid_body_entered")
	
func handle_collision():
	#queue_free()
	# Depending on our size, either destroy us or spawn children
	if asteroid_size == 0:
		queue_free()
	elif asteroid_size == 1:
		emit_signal("spawn_children", 0, position)
		queue_free()
	elif asteroid_size == 2:
		emit_signal("spawn_children", 1, position)
		queue_free()
	
func _physics_process(delta):
	position.x = position.x + direction.y * travel_speed
	position.y = position.y + direction.y * travel_speed
	rotation_degrees = rotation_degrees + (rotate_speed * (0.2 * travel_speed))
	
func _on_Asteroid_body_entered(body):
	if (not body.get("is_player") == null):
		#emit_signal("player_hit")
		body.was_hit = true