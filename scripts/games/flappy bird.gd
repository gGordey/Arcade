extends Node3D

@onready var bird = $bird
@onready var tube = preload("res://scense/minigames/flappy_tube.tscn")

const reward = 3  / 2
const starter_bird_pos = Vector3(-0.28, 0.1, -0.3)
var is_game_in_progress : bool
var gravity = 1.5#0.026
var jump_hight = 0.8
var tubes_distance = 0.9
var tubes_time = 1.6
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
	bird.velocity.z = -jump_hight
	if !is_yes_rotation: return
	if !bird.rotation.y > 0.55: bird.rotate(Vector3(0,1,0), 0.50)

func gravitate(d):
	bird.velocity.z += gravity*d
	if !is_yes_rotation: return
	if !bird.rotation.y < -0.5: bird.rotate(Vector3(0,1,0), -0.01)

var fepes = 0
func _process(delta):
	if !is_game_in_progress: return
	fepes += 1
	gravitate(delta)
	bird.move_and_slide()
	#for i in range(0, $tubes.get_children().size()):
	if $tubes.get_child_count():
		for i in range(0,$tubes.get_child_count()):
			var active_tube = $tubes.get_children()[i]
			active_tube.position.x -= tubes_speed*delta
			if active_tube.position.x < -0.9:
				active_tube.queue_free()
				G.minigame.add_score(reward)
	if $tubes_spawn.is_stopped(): generate_tubes()
	if $power_up_spawn.is_stopped():
		$power_up_spawn.wait_time = tubes_time
		generate_power_up()
		$power_up_spawn.start()
	if $reward_timer.is_stopped(): 
		$Label.set_text(str(fepes))
		fepes = 0
		G.minigame.add_score(1)
		$reward_timer.start()
	

func generate_tubes():
	var up_tube = tube.instantiate()
	var down_tube = tube.instantiate()
	if !randi_range(0,2):
		up_tube.is_mooving = true
		down_tube.is_mooving = true
		var tb_speed = randf_range(0.0025,0.005)
		up_tube.mooving_speed = tb_speed
		down_tube.mooving_speed = tb_speed
	up_tube.position = Vector3(0.81, -0.015, randf_range(-0.465,-0.815))
	up_tube.is_up = true
	down_tube.position = Vector3(0.81, -0.015, up_tube.position.z + tubes_distance)
	up_tube.rotation.y = G.to_angle(180)
	$tubes.add_child(up_tube)
	$tubes.add_child(down_tube)
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
	new_thing.position = Vector3(0.81, 0.1, pos)
	

func _on_area_3d_body_entered(body):
	if body.is_in_group('power up'):
		body.do()
	else:
		pass
		G.minigame.take_dmg()


func _on_area_3d_area_entered(area):
	if area.is_in_group('console_borders'): G.minigame.take_dmg()
	
