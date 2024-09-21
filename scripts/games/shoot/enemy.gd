extends CharacterBody3D

const HP_COLORS := {
	1:Color(0.02,0.5,0.04),
	2:Color(0.9,1,0.1),
	3:Color(0.89,0.32,0.1)
} 
var speed := 0.5
var hp : int

func _ready():
	hp = randi_range(1,3)
	change_colour()

func _process(delta):
	if !get_parent().is_game_in_progress: return
	position.z+= speed * delta

func take_dmg():
	if hp == 1:
		die()
		return
	hp-=1
	position.z -= 0.2
	speed /= 1.5
	change_colour()

func die():
	G.minigame.add_score(2)
	queue_free()

func change_colour():
	var new_mat = StandardMaterial3D.new()
	new_mat.albedo_color = HP_COLORS[hp]
	new_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	$Enemy.set_surface_override_material(1,new_mat)
