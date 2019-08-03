extends Node2D

const Stars = preload("res://Objects/Star.tscn")

export var star_count = 1000
export(Vector2) var window_size

func prepare(star_count = 1000):
	self.star_count = star_count

# Called when the node enters the scene tree for the first time.
func _ready():
	for idx in range(star_count):
		var new_star = Stars.instance()
		new_star.window_size = window_size
		new_star.prepare(false)
		add_child(new_star)
