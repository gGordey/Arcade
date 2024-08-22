extends CharacterBody3D

var is_up : bool
var dist := 0.9
var border_top = G.GAMEPAD_TOP_BORDER_POS.z
var border_bottom = G.GAMEPAD_BOTTOM_BORDER_POS.z
var is_mooving : bool
var mooving_speed = 0.002
var direction = 'up'
var dist_up
var dist_down

func _ready():
	if is_up: dist_up = 0; dist_down = dist
	else: dist_up = dist; dist_down = 0

func _physics_process(delta):
	if !G.minigame.game.is_game_in_progress: return
	if !is_mooving: return
	if direction == 'up':
		if position.z >= border_top+dist_up:
			position.z -= mooving_speed
		else:
			direction = 'down'
	if direction == 'down':
		if position.z <= border_bottom-dist_down:
			position.z += mooving_speed
		else:
			direction = 'up' 
