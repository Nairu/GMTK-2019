extends Area2D

export(bool) var cosmetic = false
export(bool) var is_asteroid = true

func _ready():
	connect("area_entered", self, "_on_Explosion_entered")
	$Explosion.play("default")
	$Explosion.connect("animation_finished", self, "_destroy")
	$CollisionShape2D.shape.radius = 18

func handle_collision():
	queue_free()	

func _process(delta):	
	# We want to dynamically change the size of the collider.
	if $Explosion.frame <= 2:
		$CollisionShape2D.shape.radius += 8
	
func _on_Explosion_entered(body):
	if cosmetic == false:
		if not body.get("is_player") == null:
			body.was_hit = true
		
func _destroy():
	queue_free()