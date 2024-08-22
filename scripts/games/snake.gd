extends Node3D

@onready var snake = $SnakeHead 
@onready var body = preload("res://scense/minigames/snake/snake_body.tscn")

const reward = 4
const speed := 0.4
const  directions = {
	'up' = Vector3(0,-1, 0),
	'right' = Vector3(1,0, -90),
	'left' = Vector3(-1,0, 90),
	'down' = Vector3(0,1, 180)
}
const posible_dirs = {
	'up': ['left','right'],
	'left': ['up','down'],
	'right': ['up','down'],
	'down': ['left','right',]
}

var neg_apple_pos : Array
var is_game_in_progress : bool
var zero_position = Vector3(-0.4, -0.09, -0.7)
var head_pos : Vector2
var apple_pos := Vector2(0,0)
var free_for_apples : Array
var last_apple_pos : Vector2
var starter_pos := Vector2(3,2)
var bodies : Array
var tile_size := 0.2
var direction : String
var free_tiles : Array
var last_position : Vector3
var is_growed : bool
var starter_size = 3
var is_yes_heal : bool
var heal_chance := 5.5

func get_pos(body):
	return Vector2(body.position.x/0.2 + 2, (body.position.z+0.1)/0.2 + 3)

func to_pos(pos : Vector2):
	return Vector2((pos.x-2)*0.2, (pos.y-3)*0.2-0.1)

func to_3d(pos_2d : Vector2):
	return Vector3(pos_2d.x, 0.09, pos_2d.y)

func click_control(tag : String):
	if tag == 'act': return
	if tag in posible_dirs[direction]:
		direction = tag

func start_game():
	for i in range(0, $bodies.get_child_count()):
		$bodies.get_children()[i].queue_free()
		bodies.clear()
	for x in [0,1,2,3,4]: for y in [0,1,2,3,4]: free_tiles.append(Vector2(x,y))
	head_pos = Vector2(randi_range(1,3), randi_range(1,3))
	snake.position = to_3d(to_pos(head_pos))
	direction = ['up', 'down', 'left', 'right'][randi_range(0, 3)]
	snake.rotation.y = G.to_angle(directions[direction].z)
	free_tiles.erase(head_pos)
	free_tiles.erase(Vector2(head_pos.x + directions[direction].x, head_pos.y + directions[direction].y))
	last_position = snake.position
	generate_starter_tail()
	free_for_apples = free_tiles
	is_yes_heal = G.chance(heal_chance)
	$moving_timer.wait_time = speed
	$moving_timer.start()
	is_game_in_progress = true
	repos_apple()
	$Gamepad.hide()

func repos_apple():
	new_power_up()
	free_for_apples = free_tiles
	while last_apple_pos in free_for_apples: free_for_apples.erase(last_apple_pos)
	$Apple.position = to_3d(to_pos(free_for_apples[randi_range(0, free_for_apples.size()-1)]))
	$Apple.rotation.y = G.to_angle([0, 90, -90, 180][randi_range(0, 3)])
	apple_pos = get_pos($Apple)
	free_for_apples.append(last_apple_pos)
	last_apple_pos = apple_pos

func grow(pos):
	var new_body = body.instantiate()
	new_body.position = pos
	$bodies.add_child(new_body)
	bodies.append(new_body)

func move():
	if head_pos.x < 1 : head_pos.x = 0
	if head_pos.y < 1 : head_pos.y = 0
	if apple_pos.x < 1 : apple_pos.x = 0
	if apple_pos.y < 1 : apple_pos.y = 0
	snake.rotation.y = G.to_angle(directions[direction].z)
	var next_head_pos = head_pos + Vector2(directions[direction].x, directions[direction].y)
	if next_head_pos == apple_pos or next_head_pos in neg_apple_pos:
		is_growed = true
		G.minigame.add_score(reward)
	if next_head_pos.x < 0 or next_head_pos.x > 4 or next_head_pos.y < 0 or next_head_pos.y > 4:
		G.minigame.take_dmg()
		return
	var body_num = bodies.size()
	var current_body_pos = snake.position
	if !bodies:
		free_tiles.append(head_pos)
		last_position = snake.position
	if bodies:
		free_tiles.erase(next_head_pos)
		free_tiles.append(get_pos(bodies[-1]))
	for i in range(0, body_num):
		last_position = bodies[i].position
		var last_body_pos = bodies[i].position
		bodies[i].position = current_body_pos
		free_tiles.erase(get_pos(bodies[i]))
		current_body_pos = last_body_pos
	if is_growed:
		repos_apple()
		grow(last_position)
		is_growed = false
	head_pos = head_pos + Vector2(directions[direction].x, directions[direction].y)
	free_tiles.erase(head_pos)
	snake.position = to_3d(to_pos(head_pos))
	
	$moving_timer.start()

func generate_starter_tail():
	var last_tail_pos = Vector2(head_pos.x-directions[direction].x,head_pos.y-directions[direction].y)
	grow(to_3d(to_pos(last_tail_pos)))
	var prev_dir = direction
	var new_drs = ['up','left','down','right']
	for i in range(0, starter_size-1):
		new_drs.erase(prev_dir)
		var new_dir = new_drs.pick_random()
		prev_dir = new_dir
		last_tail_pos = Vector2(last_tail_pos.x+directions[new_dir].x,last_tail_pos.y+directions[new_dir].y)
		grow(to_3d(to_pos(last_tail_pos)))

func new_power_up():
	var pos = free_tiles.pick_random()
	var new_pwr_up
	if is_yes_heal && G.chance(20): 
		is_yes_heal=false
		new_pwr_up = G.heal.instantiate()
	elif G.chance(heal_chance*2):
		new_pwr_up = G.power_ups.pick_random().instantiate()
	else: return
	$power_ups.add_child(new_pwr_up)
	new_pwr_up.position = to_3d(to_pos(pos))
	free_tiles.erase(pos)

func _physics_process(_delta):
	if !is_game_in_progress: return
	if $moving_timer.is_stopped(): move()

func _on_snake_area_area_entered(area):
	if area.is_in_group('snake_body'): G.minigame.take_dmg()

func _on_snake_area_body_entered(body):
	if body.is_in_group('power up'):free_tiles.append(get_pos(body)); body.do()
