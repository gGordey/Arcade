extends CharacterBody3D

@export var comb_size_range : Vector2
@export var time_range : Vector2
@export var reward : int
@export var enemy_name : String
@export var mesh_i : Mesh

var comb_size
var combination : Array
var time = randf_range(time_range.x,time_range.y)

func _ready():
	time = randf_range(time_range.x,time_range.y)
	generate_combination()
	if(mesh_i):
		$Mesh_enemy.mesh = mesh_i
	$Mesh_enemy.scale = Vector3(0.2, 0.2, 0.2)
	

func generate_combination():
	for i in range(0, randi_range(comb_size_range.x, comb_size_range.y)):
		combination.append(['up', 'left', 'right', 'down', 'act'][randi_range(0,4)])
		G.minigame.game.combination = combination
		comb_size = i + 1
