extends Node3D

var dist := 0.9
var border_top = G.GAMEPAD_TOP_BORDER_POS.z
var border_bottom = G.GAMEPAD_BOTTOM_BORDER_POS.z
var is_mooving : bool
var mooving_speed = 0.002
var direction = ['up', 'down'].pick_random()


func _physics_process(delta):
	if get_child(0).global_position.x < -0.8: queue_free()
	if !G.minigame.game.is_game_in_progress || !is_mooving: return
	if direction == 'up':
		if position.z >= border_top+0.6:
			position.z -= mooving_speed
		else:
			direction = 'down'
	elif direction == 'down':
		if position.z <= border_bottom-0.2:
			position.z += mooving_speed
		else:
			direction = 'up' 
