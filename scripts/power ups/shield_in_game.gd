extends CharacterBody3D

func do():
	G.minigame.take_shield()
	queue_free()

func _ready():
	$disepier_timer.start()

func _physics_process(delta):
	if $disepier_timer.is_stopped():
		queue_free()