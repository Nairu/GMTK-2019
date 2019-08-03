extends Node2D

signal player_was_hit

var timer = null
export (PackedScene) var enemy = load("res://Objects/Enemy.tscn")
export (PackedScene) var ui_scene = load("res://Objects/UI.tscn")
export (PackedScene) var pop_label = load("res://Objects/pop_label.tscn")

var project_resolution = Vector2()
var player_node = null
var ui_instance = null
var score = 0
var combo = 1
var base_points = 100

func _ready():
	project_resolution = Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))	
	player_node = get_node("/root/BaseNode/ShipNode")
	player_node.connect("enemy_hit", self, "_on_enemy_hit")
	
	ui_instance = ui_scene.instance()
	$CanvasLayer.add_child(ui_instance)
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(2.0)
	timer.set_one_shot(false)
	timer.start()

func _on_enemy_hit(position):
	var label_instance = pop_label.instance()
	label_instance.position = position
	label_instance.text = str(base_points * combo)
	Globals.score = (Globals.score + base_points * combo)
	combo = combo + 1
	add_child(label_instance)
	ui_instance.set_score(Globals.score)

func _on_Timer_timeout():
	var enemy_instance = enemy.instance()
	enemy_instance.set_name("Enemy")
	enemy_instance.connect("player_hit", self, "_on_player_hit")
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