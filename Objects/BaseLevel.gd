extends Node2D


var timer = null
var scene = load("res://Objects/Enemy.tscn")
var project_resolution = Vector2()

func _ready():
	project_resolution = Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))	
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(2.0)
	timer.set_one_shot(false)
	timer.start()

func _on_Timer_timeout():
	var enemy_instance = scene.instance()
	enemy_instance.set_name("Enemy")
	var edge = randf();
	
	var x = 0
	var y = 0
	
	# We can use this to choose top, bottom, left and right.
	if edge < 0.25:
		# spawn on the left edge somewhere.
		x = -20
		y = randi()%int(project_resolution.y)
	elif edge < 0.5:
		#spawn on the top edge somewhere
		x = randi()%int(project_resolution.x)
		y = -20
	elif edge < 0.75:
		#spawn on the right edge somewhere
		x = project_resolution.x + 20
		y = randi()%int(project_resolution.y)
	else:
		x = randi()%int(project_resolution.x)
		y = project_resolution.y + 20
		
	enemy_instance.position = Vector2(x,y)
	
	add_child(enemy_instance)