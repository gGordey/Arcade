extends CharacterBody3D

const HP_COLORS := {
	1:Color(0.02,0.5,0.04),
	2:Color(0.9,1,0.1),
	3:Color(0.89,0.32,0.1)
} 
var speed := 0.1
var hp : int

func _ready():
	hp = randi_range(1,3)
	change_colour()

func _process(delta):
	position.z+= speed * delta

func take_dmg():
	hp-=1

func change_colour():
	var new_mat = StandardMaterial3D.new()
	new_mat.albedo_color = HP_COLORS[hp]
	print(new_mat.albedo_color)
	new_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	$Enemy.set_surface_override_material(1,new_mat)
