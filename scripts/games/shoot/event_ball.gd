extends CharacterBody3D

var row = randi_range(0,5)
var speed := 1.0
var current_bodies := [] 

func _ready():
	print("rady event")
	$start_timer.start()

func _process(delta):
	if (!get_parent().is_game_in_progress): return
	$ball.position.z += speed * delta
	$ball.rotate_x(0.2)

func _on_start_timer_timeout():
	queue_free()

func _on_ball_zone_body_entered(body):
	if body.is_in_group("cannon"): 
		G.minigame.take_dmg()
		get_parent().is_game_in_progress = false
		return;
	if body.has_method("die"):
		body.die()
		return
	body.queue_free()
