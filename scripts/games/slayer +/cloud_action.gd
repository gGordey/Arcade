extends "res://scripts/games/slayer +/enemy_type.gd"

func _physics_process(delta):
	var percent = float(combination.size())/float(comb_size)
	if percent <= 0.4 : percent = 0.4
	$Mesh_enemy.material_override.albedo_color = Color(percent,percent,percent)
	rotate(Vector3(0,1,0), G.to_angle(0.2))
