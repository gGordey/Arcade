extends CharacterBody3D

@onready var spice_type = preload("res://scense/minigames/pointNclick/spice_type.tscn")

var is_getting_harder_cycle = false
var tile_size = 0.2
var directions = { 
	'left' = Vector3(-tile_size,0,0),
	'down' = Vector3(0,0,tile_size), # down  Vector3(tile_size,0,0)
	'up' = Vector3(0,0,-tile_size), # up Vector3(-tile_size,0,0)
	'right' = Vector3(tile_size,0,0) # rigt
}
var spikes : Array
var spike_num = randi_range(1,4)
var act_type = ['passive', 'haotic', 'follow'][randi_range(0,2)] 
var current_element : int
var move_time := randf_range(0.5, 1.2)
var act_code : Array
var pr

func _ready():
	$move_timer.wait_time = move_time
	$move_timer.start()

func set_pos():
	if !is_getting_harder_cycle:
		clean()
	if act_type != 'snake':
		if act_type == 'follow' : spike_num = 1; $move_timer.wait_time = randf_range(2.1, 3.5)
		for i in range(0, spike_num):
			var new_spike = spice_type.instantiate()
			new_spike.position = pr.to_3d(pr.to_pos(pr.free_tiles[randi_range(0, pr.free_tiles.size()-1)]))
			if act_type == 'passive': while pr.get_pos(new_spike) in pr.free_tiles: pr.free_tiles.erase(pr.get_pos(new_spike))
			$spikes.add_child(new_spike)
			spikes.append(new_spike)
	else:
		var previous_pos = pr.free_tiles[randi_range(0, pr.free_tiles.size()-1)]
		for i in range(0, spike_num):
			var new_spike = spice_type.instantiate()
			new_spike.position = pr.to_3d(pr.to_pos(previous_pos))
			$spikes.add_child(new_spike)
			spikes.append(new_spike)
			var next = Vector2(randi_range(-1, 1), 0)
			if next.x == 0: next.y = [-1, 1][randi_range(0,1)]
			previous_pos = pr.get_pos(new_spike) + next
		for i in range(2, 7):
			act_code.append(['up', 'down', 'left', 'right'][randi_range(0, 3)])

func clean():
	for i in range(0, spikes.size()):
		spikes[i].queue_free()
	spikes.clear()

func _physics_process(delta):
	if !G.minigame.game.is_game_in_progress:
		return
	if !$move_timer.is_stopped(): return
	$move_timer.start()
	if act_type == 'haotic':
		for i in range(0, spikes.size()):
			if pr.get_pos(spikes[i]).x >= 4: spikes[i].position.x += -pr.tile_size; return
			elif pr.get_pos(spikes[i]).x <= 0: spikes[i].position.x += pr.tile_size; return
			elif pr.get_pos(spikes[i]).y >= 4: spikes[i].position.z += -pr.tile_size; return
			elif pr.get_pos(spikes[i]).y <= 0: spikes[i].position.z += pr.tile_size; return
			spikes[i].position.x += directions[['up', 'down', 'left', 'right'][randi_range(0, 3)]].x
			spikes[i].position.z += directions[['up', 'down', 'left', 'right'][randi_range(0, 3)]].z
	if act_type == 'follow':
		for i in range(0, spikes.size()):
			if pr.get_pos(spikes[i]).x != pr.scope_pos.x:
				if pr.get_pos(spikes[i]).x >= pr.scope_pos.x: spikes[i].position.x += directions['left'].x
				elif pr.get_pos(spikes[i]).x <= pr.scope_pos.x: spikes[i].position.x += directions['right'].x
			else:
				if pr.get_pos(spikes[i]).y >= pr.scope_pos.y: spikes[i].position.z += directions['up'].z
				elif pr.get_pos(spikes[i]).y <= pr.scope_pos.y: spikes[i].position.z += directions['down'].z
	if act_type == 'snake':
		var previous_pos = spikes[0].position
		for i in range(0, spikes.size()):
			if i == 0: spikes[0].position += directions[act_code[current_element - 1]]
			else:
				var cr_pos = spikes[i].position
				spikes[i].position = previous_pos
				previous_pos = cr_pos
		if current_element < act_code.size(): current_element += 1
		else: current_element = 0
	
