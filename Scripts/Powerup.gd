extends Node2D

export var life_duration = 5
var current_life = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	print("Test")
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_life += delta
	if current_life >= life_duration:
		queue_free()	
	#pass
