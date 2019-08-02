extends KinematicBody2D

var direction = Vector2(0, 1)
var area = null

func _physics_process(delta):
	move_and_slide(direction)
