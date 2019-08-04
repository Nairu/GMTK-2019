extends Node2D

signal player_was_hit

const Powerup = preload("res://Scripts/Powerup.gd")

var timer = null
var timer_enemy = null
var timer_asteroid = null
export (PackedScene) var enemy_flier
export (PackedScene) var enemy_follower
export (PackedScene) var enemy_circler
export (PackedScene) var enemy_bomber

export (PackedScene) var asteroid_large = load("res://Objects/AsteroidLarge.tscn")
export (PackedScene) var asteroid_medium = load("res://Objects/AsteroidMedium.tscn")
export (PackedScene) var asteroid_small = load("res://Objects/AsteroidSmall.tscn")

export (PackedScene) var ui_scene = load("res://Objects/UI.tscn")
export (PackedScene) var pop_label = load("res://Objects/pop_label.tscn")
export (PackedScene) var player = load("res://Objects/Player.tscn")
export (PackedScene) var starfield = load("res://Objects/Starfield.tscn")

export (PackedScene) var powerup_trail = load("res://Objects/Powerups/Powerup.tscn")

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
	#player_node.connect("enemy_hit", self, "_on_enemy_hit")
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
	
	timer_enemy = Timer.new()
	add_child(timer_enemy)
	
	timer_enemy.connect("timeout", self, "_on_timer_enemy_timeout")
	timer_enemy.set_wait_time(2.0)
	timer_enemy.set_one_shot(false)
	timer_enemy.start()
	
	timer_asteroid = Timer.new()
	add_child(timer_asteroid)
	
	timer_asteroid.connect("timeout", self, "_on_timer_asteroid_timeout")
	timer_asteroid.set_wait_time(5.0)
	timer_asteroid.set_one_shot(false)
	timer_asteroid.start()

func _process(delta):
	player_viewable_bounds = Rect2(player_node.position.x - screen_size.x/2, 
								   player_node.position.y - screen_size.y/2,
								   screen_size.x,
								   screen_size.y)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_enemy_hit(position, reward_player):
	if reward_player:
		var label_instance = pop_label.instance()
		label_instance.position = position
		label_instance.text = str(base_points * combo)
		Globals.score = (Globals.score + base_points * combo)
		combo = combo + 1
		add_child(label_instance)
		ui_instance.set_score(Globals.score)
		
		var powerup =  powerup_trail.instance()
		
		var perc = randf()
		var powerup_type = null
		
		if perc < 1:
			perc = int(rand_range(0, 2))
			
			if perc == 0:
				powerup_type = powerup.Powerup_Type.SHIELD
			elif perc == 1:
				powerup_type = powerup.Powerup_Type.SPREAD
				
			powerup.prepare(powerup_type)
			powerup.position = position
			powerup.connect("powerup_pickup", self, "_on_powerup_pickup")
			add_child(powerup)

func _on_timer_enemy_timeout():
	var enemy_instance
	
	var chance = randf()
	if chance < 0.1:
		enemy_instance = enemy_bomber.instance()
	elif chance < 0.3:
		enemy_instance = enemy_follower.instance()
	else:
		enemy_instance = enemy_flier.instance()
	
	enemy_instance.set_name("Enemy")
	#enemy_instance.connect("player_hit", self, "_on_player_hit")
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
	enemy_instance.connect("enemy_died", self, "_on_enemy_hit")
	
	add_child(enemy_instance)
	
func _on_timer_asteroid_timeout():
	var asteroid_instance = null
	var chance = randf()
	
	if chance < 0.5:
		asteroid_instance = asteroid_medium.instance()
	elif chance < 0.75:
		asteroid_instance = asteroid_large.instance()
	else:
		asteroid_instance = asteroid_small.instance()
	
	asteroid_instance.set_name("ROID!")
	
	var edge = randf();	
	
	var x = 0
	var y = 0
	
	# We can use this to choose top, bottom, left and right.
	if edge < 0.25:
		# spawn on the left edge somewhere.
		x = player_viewable_bounds.position.x - 100
		y = player_viewable_bounds.position.y + randi()%int(player_viewable_bounds.size.y)
	elif edge < 0.5:
		#spawn on the top edge somewhere
		x = player_viewable_bounds.position.x + randi()%int(player_viewable_bounds.size.x)
		y = player_viewable_bounds.position.y - 100
	elif edge < 0.75:
		#spawn on the right edge somewhere
		x = player_viewable_bounds.end.x + 100
		y = player_viewable_bounds.end.y - randi()%int(player_viewable_bounds.size.y)
	else:
		x = player_viewable_bounds.end.x - randi()%int(player_viewable_bounds.size.x)
		y = player_viewable_bounds.end.y + 100
		
	if not player_viewable_bounds.has_point(Vector2(x,y)):
		asteroid_instance.position = Vector2(x,y)
	
	asteroid_instance.connect("spawn_children", self, "spawn_asteroid_children")
	
	add_child(asteroid_instance)
	
func spawn_asteroid_children(size, position):
	var unit_vector = (player_node.position - position).normalized();
	#make direction perpendicular.
	var player_direction = player_node.motion.normalized()
	var angle_difference = player_direction.dot(unit_vector)
	
	var direction = Vector2(cos(angle_difference), sin(angle_difference))
	
	var asteroid_instance = null
	if size == 1:
		asteroid_instance = asteroid_medium.instance()
	else:
		asteroid_instance = asteroid_small.instance()
	
	asteroid_instance.set_name("ROID!")
	asteroid_instance.position = position + direction*10
	asteroid_instance.connect("spawn_children", self, "spawn_asteroid_children")
	add_child(asteroid_instance)
	asteroid_instance.direction = direction;
	asteroid_instance.asteroid_size = size
	
	var asteroid_instance_2 = null
	if size == 1:
		asteroid_instance_2 = asteroid_medium.instance()
	else:
		asteroid_instance_2 = asteroid_small.instance()
		
	asteroid_instance_2.set_name("ROID!")
	asteroid_instance_2.position = position + direction*-10
	asteroid_instance_2.connect("spawn_children", self, "spawn_asteroid_children")
	add_child(asteroid_instance_2)
	asteroid_instance_2.direction = direction*-1;
	asteroid_instance.asteroid_size = size
		
func _on_powerup_pickup(powerup):
	if powerup ==  Powerup.Powerup_Type.SPREAD:
		player_node.change_weapon(player_node.Weapon_Type.SPREAD, true, 5)
	pass
