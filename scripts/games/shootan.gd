extends Node3D

@onready var bullet = preload("res://scense/minigames/shootan/bullet.tscn")

const ROWS_COUNT := 5
const Z_POSITION := 0.184
const ROW_SIZE := 0.19
const DIRECTIONS := {'left':-1,'right':1}
var current_row := 0
var is_game_in_progress : bool
var can_shoot : bool

func start_game():
	$cannon.position.z = Z_POSITION
	current_row = 2
	is_game_in_progress = true
	$Gamepad.hide()
	$enemy_spawn.start()
	$shoot_timer.start()

func click_control(tag: String):
	if !is_game_in_progress: return
	if tag in DIRECTIONS.keys(): move_cannon(DIRECTIONS[tag])
	if tag in ['up', 'act']: shoot()

func move_cannon(dir:int):
	if !current_row+dir in range(0,5): return
	current_row+=dir
	$cannon.position.x = current_row*ROW_SIZE-(ROW_SIZE*2)

func _process(delta):
	if !is_game_in_progress : return
	if $shoot_timer.is_stopped(): can_shoot=true

func shoot():
	if !can_shoot: return
	var new_bullet = bullet.instantiate()
	new_bullet.position.x = $cannon.position.x
	$bullets.add_child(new_bullet)
	can_shoot=false
	$shoot_timer.start()
