extends Node3D

@onready var enemy = preload("res://scense/minigames/pointNclick/enemy.tscn")
@onready var scope = $ScopeActive
@onready var target = $Target

const reward = 6
const  directions = {
	'up' = Vector2(0,-1),
	'right' = Vector2(1,0),
	'left' = Vector2(-1,0),
	'down' = Vector2(0,1)
}

var field_size := Vector2(4,4)
var starter_pos : Vector2
var target_pos : Vector2
var is_game_in_progress : bool
var movement_reload := 0.09
var zero_position = Vector3(-0.4, -0.09, -0.7)
var tile_size := 0.2
var scope_pos : Vector2
var enemyes : Array
var last_target_pos = Vector2(0,0)
var free_tiles : Array
var is_getting_harder : bool

func get_pos(body):
	return Vector2(body.position.x/tile_size + 2, (body.position.z+0.1)/tile_size + 3)

func to_pos(pos : Vector2):
	return Vector2((pos.x-2)*tile_size, (pos.y-3)*tile_size-0.1)

func to_3d(pos_2d : Vector2):
	return Vector3(pos_2d.x, 0.09, pos_2d.y)

func click_control(tag: String):
	if tag != 'act':
		move(tag)
	else:
		eat() 

func start_game():
	for x in [0,1,2,3,4]: for y in [0,1,2,3,4]: free_tiles.append(Vector2(x,y))
	if !is_getting_harder:
		for i in range(0, $env.get_child_count()):
			$env.get_children()[i].queue_free()
	for i in range(1, 3):
		var new_enemy = enemy.instantiate()
		new_enemy.pr = self
		$env.add_child(new_enemy)
		new_enemy.set_pos()
		enemyes.append(new_enemy)
	if !starter_pos: starter_pos = Vector2(randi_range(0, field_size.x), randi_range(0, field_size.y))
	scope.position = to_3d(to_pos(starter_pos))
	scope_pos = get_pos(scope)
	free_tiles.erase(scope_pos)
	repos_target()
	$move_reload.wait_time = movement_reload
	$move_reload.start()
	$position_change_timer.start()
	is_game_in_progress = true
	$Gamepad.hide()

func move(tag : String):
	if !is_game_in_progress:
		return
	if !$move_reload.is_stopped(): return
	free_tiles.append(scope_pos)
	if scope_pos.x < 1 : scope_pos.x = 0
	if scope_pos.y < 1 : scope_pos.y = 0
	var next_scope_pos = scope_pos + Vector2(directions[tag].x, directions[tag].y)
	if next_scope_pos.x < 0 or next_scope_pos.x > 4 or next_scope_pos.y < 0 or next_scope_pos.y > 4:
		#G.minigame.take_dmg()
		return
	free_tiles.append(scope_pos)
	scope_pos += directions[tag]
	scope.position = to_3d(to_pos(scope_pos))
	free_tiles.erase(scope_pos)
	$move_reload.start()

func eat():
	if !is_game_in_progress:
		return
	if scope_pos == target_pos:
		G.minigame.add_score(reward)
		repos_target()
	else:
		G.minigame.take_dmg()


func repos_target():
	while last_target_pos in free_tiles: free_tiles.erase(last_target_pos)
	target.position = to_3d(to_pos(free_tiles[randi_range(0, free_tiles.size()-1)]))
	target_pos = get_pos(target)
	if target_pos.x < 1 : target_pos.x = 0
	if target_pos.y < 1 : target_pos.y = 0
	free_tiles.append(last_target_pos)
	last_target_pos = target_pos
	$position_change_timer.start()

func _physics_process(_delta):
	if !is_game_in_progress:
		return
	target.rotate_y(G.to_angle(0.55))
	if $position_change_timer.is_stopped():
		repos_target()
		
