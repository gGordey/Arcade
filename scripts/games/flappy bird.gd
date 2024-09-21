extends Node3D

@onready var bird = $bird
@onready var tube = preload("res://scense/minigames/flappy_tube.tscn")
@onready var claster = preload("res://scense/minigames/tubes_claster.tscn")

const reward = 3  / 2
const starter_bird_pos = Vector3(-0.28, 0.1, -0.3)
var is_game_in_progress : bool
var _d : float
var gravity = 0.025
var jump_hight = 0.014
var tubes_distance = 0.9
var tubes_time = 1.6
var vel := 0.0
var tubes_speed = 1#0.012
var is_yes_rotation = false
var heal_chance := 5.5
var is_yes_heal : bool

func click_control(tag : String):
	jump()

func start_game():
	bird.position = starter_bird_pos
	bird.velocity = Vector3.ZERO
	is_game_in_progress = true
	for i in range(0, $tubes.get_children().size()): $tubes.get_children()[i].queue_free()
	is_yes_heal = G.chance(heal_chance)
	$tubes_spawn.wait_time = tubes_time
	$power_up_spawn.wait_time = tubes_time + (tubes_time/2)
	$tubes_spawn.start()
	$power_up_spawn.start()
	$Gamepad.hide()

func jump():
	vel = -jump_hight

func gravitate(d):
	bird.position.z += vel
	vel += gravity*d

func _physics_process(delta):
	if !is_game_in_progress: return
	gravitate(delta)
	bird.move_and_slide()
	$Label.set_text(str(1/delta))
	#for i in range(0, $tubes.get_children().size()):
	$tubes.position.x -= tubes_speed*delta
	

func generate_tubes():
	var up_tube = tube.instantiate()
	var down_tube = tube.instantiate()
	var new_claster = claster.instantiate()
	if !randi_range(0,2):
		new_claster.is_mooving = true
		new_claster.mooving_speed = randf_range(0.0025,0.005)
	$tubes.add_child(new_claster)
	new_claster.add_child(up_tube)
	new_claster.add_child(down_tube)
	up_tube.global_position = Vector3(0.81, -0.015, randf_range(-0.465,-0.815))
	down_tube.global_position = Vector3(0.81, -0.015, up_tube.global_position.z + tubes_distance)
	up_tube.rotation.y = G.to_angle(180)
	$tubes_spawn.start()

func generate_power_up():
	#-0.28, 0.1, -0.3
	var new_thing
	if is_yes_heal && G.chance(20):
		new_thing = G.heal.instantiate()
		is_yes_heal = false
		new_thing.rotation.x = G.to_angle(-70)
	elif G.chance(heal_chance*2): 
		new_thing = G.power_ups.pick_random().instantiate()
		new_thing.rotation.z = G.to_angle(-70)
	else: return
	var pos = randf_range(G.GAMEPAD_TOP_BORDER_POS.y+0.2,G.GAMEPAD_BOTTOM_BORDER_POS.y-0.2)
	$tubes.add_child(new_thing)
	new_thing.global_position = Vector3(0.81, 0.1, pos)

func _on_area_3d_body_entered(body):
	if body.is_in_group('power up'):
		body.do()
	else:
		pass
		G.minigame.take_dmg()

func _on_area_3d_area_entered(area):
	if area.is_in_group('console_borders'): G.minigame.take_dmg()

func _on_tubes_spawn_timeout():
	if !is_game_in_progress : return
	generate_tubes()

func _on_power_up_spawn_timeout():
	if !is_game_in_progress : return
	$power_up_spawn.wait_time = tubes_time
	generate_power_up()
	$power_up_spawn.start()


func _on_reward_timer_timeout():
	if !is_game_in_progress : return
	G.minigame.add_score(2)
	$reward_timer.start()
