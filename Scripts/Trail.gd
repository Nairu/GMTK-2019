extends Node2D

var target
var point
export(NodePath) var targetPath
export var trail_length = 0
export(Gradient) var trail_colour

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetPath)
	
	$Trail.gradient = trail_colour
	
	self.connect("area_entered", self, "_on_trail_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector2(0, 0)
	global_rotation = 0
	
	point = target.global_position
	$Trail.add_point(point)		
	$StaticBody2D/TrailHitBox.polygon.append(point)
		
	while $Trail.get_point_count() > trail_length:
		$Trail.remove_point(0)
		#$StaticBody2D.polygon.remove(0)	
	pass

func _on_trail_entered():
	print("hit!")