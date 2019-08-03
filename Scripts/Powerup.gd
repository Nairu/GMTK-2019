extends Node2D

signal powerup_trail_pickup

export var life_duration = 5
var current_life = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "_on_powerup_body_entered") 
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_life += delta
	if current_life >= life_duration:
		queue_free()	
	#pass

func _on_powerup_body_entered(body):	
	if body.name == "Player":
		emit_signal("powerup_trail_pickup")
		queue_free()
	pass