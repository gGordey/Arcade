extends Node3D

var starter_pos := Vector3(-0.4, 0.26, -0.9)
var heart_count : int = 4
var step : float = 0.8 / heart_count
var is_shielded : bool

func clear_hearts():
	for i in range(0, get_child_count()):
		get_children()[i].queue_free()

func fill_hearts():
	clear_hearts()
	for i in range(0, heart_count):
		add_heart(i+1)

func del_heart():
	var l_ind = get_child_count()-1
	if get_child_count():
		if is_shielded: get_children()[l_ind].un_shield();is_shielded=false; return
		get_children()[l_ind].queue_free()

func add_heart(hp):
	var heart = load("res://scense/heart.tscn").instantiate()
	add_child(heart)
	heart.position = Vector3(starter_pos.x + step*(hp-1), starter_pos.y, starter_pos.z)

func add_shield():
	get_children()[get_child_count()-1].shield()
	is_shielded = true
func del_shield():
	get_children()[get_child_count()-1].un_shield()
	is_shielded = false
#func _physics_process(delta):
#	for i in range(0, get_child_count()):
#		get_children()[i].rotate(Vector3(0,0,1), G.to_angle(0.4))
