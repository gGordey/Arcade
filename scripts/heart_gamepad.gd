extends Node3D



func _ready():
	pass # Replace with function body.

func shield():
	$Shield.show()

func un_shield():
	$Shield.hide()

func _physics_process(delta):
	$heart.rotate_z(G.to_angle(0.4))
