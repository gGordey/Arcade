extends StaticBody3D

var move_speed := 1.5

var skp :int
func _process(delta):
	skp+=1
	if !skp>=2: return
	skp = 0
	position.z -= move_speed*delta*2
	if position.z >=3: queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group('enemy'):
		body.queue_free()
		queue_free()
