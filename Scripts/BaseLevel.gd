extends Node2D

signal player_was_hit

var timer = null
export (PackedScene) var enemy = load("res://Objects/Enemy.tscn")
export (PackedScene) var ui_scene = load("res://Objects/UI.tscn")
export (PackedScene) var pop_label = load("res://Objects/pop_label.tscn")
export (PackedScene) var player = load("res://Objects/Player.tscn")
export (PackedScene) var starfield = load("res://Objects/Starfield.tscn")

export (PackedScene) var powerup_trail = load("res://Objects/Powerups/Powerup-Trail.tscn")

export (Vector2) var play_area = Vector2(10000, 10000)

var player_viewable_bounds = Rect2(0, 0, 1, 1)

var screen_size

var project_resolution = Vector2()
var player_node = null
var ui_instance = null
var starfield_instance = null
var score = 0
var combo = 1
var base_points = 100

var powerup = null

func _ready():
	player_node = player.instance()
	player_node.connect("enemy_hit", self, "_on_enemy_hit")
	player_node.position = Vector2(play_area.x / 2, play_area.y / 2)
	player_node.name = "Player"
	add_child(player_node)
	
	starfield_instance = starfield.instance()
	starfield_instance.window_size = play_area
	starfield_instance.position = Vector2(0,0)
	starfield_instance.star_count = 5000
	add_child(starfield_instance)
	
	screen_size = get_viewport_rect().size
	
	ui_instance = ui_scene.instance()
	$CanvasLayer.add_child(ui_instance)
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(2.0)
	timer.set_one_shot(false)
	timer.start()

func _process(delta):
	player_viewable_bounds = Rect2(player_node.position.x - screen_size.x/2, 
								   player_node.position.y - screen_size.y/2,
								   screen_size.x,
								   screen_size.y)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_enemy_hit(position):
	var label_instance = pop_label.instance()
	label_instance.position = position
	label_instance.text = str(base_points * combo)
	Globals.score = (Globals.score + base_points * combo)
	combo = combo + 1
	add_child(label_instance)
	ui_instance.set_score(Globals.score)
	
	var powerup =  powerup_trail.instance()
	powerup.prepare(powerup.Powerup_Type.TRAIL)
	powerup.position = position
	powerup.connect("powerup_trail_pickup", self, "_on_powerup_trail_pickup")
	add_child(powerup)

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
		x = player_viewable_bounds.position.x + 20
		y = player_viewable_bounds.position.y + randi()%int(player_viewable_bounds.size.y)
	elif edge < 0.5:
		#spawn on the top edge somewhere
		x = player_viewable_bounds.position.x + randi()%int(player_viewable_bounds.size.x)
		y = player_viewable_bounds.position.y + 20
	elif edge < 0.75:
		#spawn on the right edge somewhere
		x = player_viewable_bounds.end.x - 20
		y = player_viewable_bounds.end.y - randi()%int(player_viewable_bounds.size.y)
	else:
		x = player_viewable_bounds.end.x - randi()%int(player_viewable_bounds.size.x)
		y = player_viewable_bounds.end.y - 20
		
	enemy_instance.position = Vector2(x,y)
	
	add_child(enemy_instance)
	
func _on_powerup_trail_pickup(powerup):
	print(powerup)