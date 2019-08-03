extends Area2D

var direction = Vector2(0, 1)
var area = null

signal enemy_hit

func _ready():
	connect("area_entered", self, "_on_Bullet_body_entered")

func _physics_process(delta):
	#move_and_slide(direction)
	position.x = lerp(position.x, position.x + direction.x, delta)
	position.y = lerp(position.y, position.y + direction.y, delta)
	
func _on_Bullet_body_entered(body):
	if (not body.get("is_enemy") == null):
		body.queue_free()
		emit_signal("enemy_hit", body.position)