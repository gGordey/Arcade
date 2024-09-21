extends Node3D

@onready var bullet = preload("res://scense/minigames/shootan/bullet.tscn")
@onready var enemy = preload("res://scense/minigames/shootan/enemy.tscn")
@onready var events = [
	preload("res://scense/minigames/shootan/events/event_ball.tscn"),
]


const ROWS_COUNT := 5
const Z_POSITION := 0.184
const ROW_SIZE := 0.19
const DIRECTIONS := {'left':-1,'right':1}
var current_row := 0
var is_game_in_progress : bool
var can_shoot : bool
var heal_chance := 5.5
var event_chance := 10.0
var is_yes_heal : bool

func start_game():
	$cannon.position.z = Z_POSITION
	current_row = 2
	is_game_in_progress = true
	is_yes_heal = G.chance(heal_chance)
	$Gamepad.hide()
	$enemy_spawn.start()
	$shoot_timer.start()
	$event_timer.start()

func click_control(tag: String):
	if !is_game_in_progress: return
	if tag in DIRECTIONS.keys(): move_cannon(DIRECTIONS[tag])
	if tag in ['up', 'act', 'down']: shoot()

func move_cannon(dir:int):
	if !current_row+dir in range(0,5): return
	current_row+=dir
	$cannon.position.x = current_row*ROW_SIZE-(ROW_SIZE*2)

func generate_enemy():
	if generate_powerup(): return
	var new_enemy = enemy.instantiate()
	var row := randi_range(0,4)
	new_enemy.position.x = row*ROW_SIZE-(ROW_SIZE*2)
	new_enemy.position.z = -0.8
	add_child(new_enemy)

func generate_event():
	if !G.chance(event_chance): return
	var new_event_node = events.pick_random().instantiate()
	add_child(new_event_node)
	new_event_node.position.x = randi_range(0,4)*ROW_SIZE-(ROW_SIZE*2)

func _physics_process(delta):
	if !is_game_in_progress : return
	$pwrup.position.z += 0.3*delta

func shoot():
	if !can_shoot: return
	var new_bullet = bullet.instantiate()
	new_bullet.position.x = $cannon.position.x
	$bullets.add_child(new_bullet)
	can_shoot=false
	$shoot_timer.start()

func generate_powerup() -> bool:
	var new_power_up
	if is_yes_heal && G.chance(20):
		new_power_up = G.heal.instantiate()
		is_yes_heal = false
	elif G.chance(heal_chance*2):
		new_power_up = G.power_ups.pick_random().instantiate()
	else:
		return false
	var row := randi_range(1,4)
	$pwrup.add_child(new_power_up)
	new_power_up.global_position.x = row*ROW_SIZE-(ROW_SIZE*2)
	new_power_up.global_position.z = -0.8
	return true

func new_event():
	# ROLLING BALL
	var row = randi_range(0, 5)
	

func _on_area_3d_body_entered(body):
	if !body.is_in_group("enemy"): return
	G.minigame.take_dmg()
	is_game_in_progress = false


func _on_event_timer_timeout():
	#$event_timer.start()
	generate_event()

func _on_enemy_spawn_timeout():
	#$enemy_spawn.start()
	generate_enemy()

func _on_shoot_timer_timeout():
	can_shoot=true
