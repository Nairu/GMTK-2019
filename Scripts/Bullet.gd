extends Area2D

var direction = Vector2(0, 1)
var area = null

export (PackedScene) var pop_label = load("res://Objects/pop_label.tscn")

func _ready():
	connect("area_entered", self, "_on_Bullet_body_entered")

func _physics_process(delta):
	#move_and_slide(direction)
	position.x = lerp(position.x, position.x + direction.x, delta)
	position.y = lerp(position.y, position.y + direction.y, delta)
	
func _on_Bullet_body_entered(body):
	if (not body.get("is_enemy") == null):
		body.queue_free()
		var label_instance = pop_label.instance()
		label_instance.position = body.position
		get_parent().get_parent().add_child(label_instance)