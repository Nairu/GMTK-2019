extends Node2D

signal powerup_pickup

enum Powerup_Type { SHIELD, SPREAD, BOMB, CROSS }
var powerup = null

export var life_duration = 5
var current_life = 0
var player = null

func prepare(powerup):
	self.powerup = powerup
	
	if powerup == Powerup_Type.SHIELD:
		$"Powerup-Shield".visible = true
	elif powerup == Powerup_Type.SPREAD:
		$"Powerup-Spread".visible = true
	elif powerup == Powerup_Type.BOMB:
		$"Powerup-Bomb".visible = true
	elif powerup == Powerup_Type.CROSS:
		$"Powerup-Cross".visible = true
	else:
		pass

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "_on_powerup_body_entered") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Sprite.rotation_degrees += 3
	   
	if position.distance_to(player.position) < 150:
		var direction = (player.get_transform().origin - get_transform().origin).normalized()
		position.x = lerp(position.x, position.x + (direction.x * 400), delta)
		position.y = lerp(position.y, position.y + (direction.y * 400), delta)
	
	if powerup == Powerup_Type.SHIELD:
		$"Powerup-Shield".play("Idle")
	elif powerup == Powerup_Type.SPREAD:
		$"Powerup-Spread".play("Idle")
	elif powerup == Powerup_Type.BOMB:
		$"Powerup-Bomb".play("Idle")
	elif powerup == Powerup_Type.CROSS:
		$"Powerup-Cross".play("Idle")		
	current_life += delta
	
	if current_life >= life_duration:
		queue_free()	

func _on_powerup_body_entered(body):	
	if body.name == "Player":
		emit_signal("powerup_pickup", powerup)
		queue_free()