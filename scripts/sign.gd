extends MeshInstance3D

func _physics_process(delta):
	if $Timer.is_stopped():
		queue_free()
