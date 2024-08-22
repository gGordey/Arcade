extends Node3D

var is_game_in_progress : bool
var passive_enemy_list = [
	preload("res://scense/minigames/driver/cone.tscn"),
	preload("res://scense/minigames/driver/shina.tscn")
]
var moving_enemy_list = [
	preload("res://scense/minigames/driver/gruzovick.tscn"),
	preload("res://scense/minigames/driver/legchovyshka.tscn")
]
var current_st_enemyes : Array
var current_mv_enemyes : Array
var is_yes_heal : bool
var heal_chance := 5.5
var car_speed = 1.05#0.015
var lateral_speed = 0.7#0.6 #left right

var road_parts : Array
var road_dist := 0.45
var part_y = -0.094
var part_size = 0.28
var parts_amound = 8

func click_control(tag : String):
	pass
	#if tag == 'act':
	#	car_speed = 0

func start_game():
	is_game_in_progress = true
	is_yes_heal = G.chance(heal_chance)
	fill_road()
	$spawnTimer.start()
	$Gamepad.hide()

func movement(d):
	if 'right' in G.active_btn:
		$car.position.x += lateral_speed*d
		$car.rotation.y = G.to_angle(-12)
	elif 'left' in G.active_btn:
		$car.position.x -= lateral_speed*d
		$car.rotation.y = G.to_angle(12)
	else: $car.rotation.y = G.to_angle(0)
	if 'up' in G.active_btn:
		car_speed += 0.005
	elif 'down' in G.active_btn:
		if car_speed-0.005 >= 0.4:
			car_speed -= 0.005

var fepes = 0
func _process(delta):
	if !is_game_in_progress: return
	fepes+=1
	if $reward_timer.is_stopped(): 
		$Label.set_text(str(fepes))
		fepes = 0
		G.minigame.add_score(1)
		$reward_timer.start()
	if $spawnTimer.is_stopped():
		#spawn_enemy(false)
		spawn_enemy(randi_range(0,1))
		#$spawnTimer.wait_time -= 0.05
		$spawnTimer.start()
	for i in range(0, current_st_enemyes.size()):
		current_st_enemyes[i].position.z += car_speed*delta
	for i in range(0, current_mv_enemyes.size()):
		current_mv_enemyes[i][0].position.z += current_mv_enemyes[i][1]*delta + car_speed*delta
	movement(delta)
	move_road(delta)


func spawn_enemy(is_mooving : bool):
	for i in range(0, current_st_enemyes.size()):
		if current_st_enemyes.size() > i && current_st_enemyes[i].position.z >= 0.47:
			current_st_enemyes[i].queue_free()
			current_st_enemyes.erase(current_st_enemyes[i])
	var new_enemy
	if is_mooving:
		var speed = randf_range(-2,1)
		new_enemy = moving_enemy_list[randi_range(0,moving_enemy_list.size()-1)].instantiate()
		if speed > 0:
			new_enemy.position = Vector3(randf_range(-0.315,0.315),-0.03,-1.3 + -(speed)*5)
			speed += 0.5
		else:
			speed -= 0.6
			new_enemy.rotation.y = G.to_angle(180)
			new_enemy.position = Vector3(randf_range(-0.315,0.315),-0.03, 1.1)
		current_mv_enemyes.append([new_enemy, speed])
		mark_car(new_enemy.position.x, speed)
	else:
		new_enemy = passive_enemy_list[randi_range(0,passive_enemy_list.size()-1)].instantiate()
		if is_yes_heal && G.chance(20): new_enemy = G.heal.instantiate(); is_yes_heal = false
		elif G.chance(heal_chance*2): new_enemy = G.power_ups.pick_random().instantiate();
		current_st_enemyes.append(new_enemy)
		new_enemy.position = Vector3(randf_range(-0.315,0.315),-0.03,-1.15)
	$enm.add_child(new_enemy)

func mark_car(x, spd):
	var z
	if spd>0:
		z=-0.685
	else:
		#if !spd+car_speed < 0: return
		z=0.4
	var new_sign = load("res://scense/sign.tscn").instantiate()
	new_sign.position = Vector3(x, 0.25, z)
	add_child(new_sign)

func new_road(pos):
	var road_part = MeshInstance3D.new()
	road_part.mesh = load("res://assets/3d/games/drive/road part.obj")
	road_part.position = pos
	road_parts.append(road_part)
	$parts.add_child(road_part)

func fill_road():
	for i in range(0, parts_amound):
		new_road(Vector3(0,part_y, 0-(i*road_dist)))

func move_road(d):
	for i in range(0,road_parts.size()):
		road_parts[i].position.z += car_speed*d
	if road_parts[0].position.z >= 0.78:
		road_parts[0].position.z = road_parts[parts_amound-1].position.z - road_dist
		var rp0 = road_parts[0]
		road_parts.erase(road_parts[0])
		road_parts.append(rp0)


func _on_area_3d_body_entered(body):
	if body.is_in_group('enemy') or body.is_in_group('border'):
		G.minigame.take_dmg()
	elif body.is_in_group('power up'):
		current_st_enemyes.erase(body)
		body.do()

func _on_area_3d_area_entered(area):
	if area.is_in_group('console_borders'): G.minigame.take_dmg()


func _on_score_area_body_entered(body):
	if body.is_in_group('enemy'):
		G.minigame.add_score(1)
