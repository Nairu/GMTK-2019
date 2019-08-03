extends Node2D

var x = 0
var y = 0

var radius = 5
var colour = Color.white

var speed = 0

var is_static = false

#onready var window_size = get_viewport_rect().size
export(Vector2) var window_size

func prepare(is_static):
	self.is_static = is_static

# Called when the node enters the scene tree for the first time.
func _ready():
	x = rand_range(0, window_size.x)
	y = rand_range(0, window_size.y)

	radius = rand_range(1, 1.2)
	colour = Color(.9, .9, rand_range(.4, .8), rand_range(.1, .5))

	if not is_static:
		speed = rand_range(5, 15)

	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_static:
		var distance = speed * delta
		y += distance
		
		if y > window_size.y:
			y = -1
	update()

func _draw():
	# Draw star
	draw_circle(Vector2(x, y), radius, colour)