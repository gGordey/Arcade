extends Node3D

var enemys_l := [
	"res://scense/minigames/slayer/enemys/goblin.tscn",
	"res://scense/minigames/slayer/enemys/skull.tscn",
	"res://scense/minigames/slayer/enemys/cloud.tscn",
]
var current_enemy
var prev_enemy
var is_game_in_progress : bool
var needed_score = 45
var combination : Array
var show_comb_lenth = 4
var hp
var shield := true

func click_control(tag : String):
	if !is_game_in_progress: return
	if tag == combination[0]: sucsesful_clik()
	elif shield: shield=false; return
	else: G.minigame.take_dmg()

func start_game():
	is_game_in_progress = true
	for i in range(0, $s/ui/dialog/grid.get_child_count()): $s/ui/dialog/grid.get_children()[i].queue_free()
	new_rand_enemy()
	$Gamepad.hide()

func _physics_process(_delta):
	if !is_game_in_progress: return

func sucsesful_clik():
	if combination.size() > show_comb_lenth: new_arrow(combination[show_comb_lenth])
	combination.erase(current_enemy.combination[0])
	if !combination: kill_enemy()
	$s/ui/dialog/grid.get_children()[0].queue_free()

func kill_enemy():
	G.minigame.add_score(current_enemy.reward)
	current_enemy.queue_free()
	for i in range(0, $s/ui/dialog/grid.get_child_count()): $s/ui/dialog/grid.get_children()[i].queue_free()
	
	new_rand_enemy()

func new_rand_enemy():
	var enm_path = enemys_l[randi_range(0, enemys_l.size()-1)]
	var enemy = load(enm_path).instantiate()
	if prev_enemy: enemys_l.append(prev_enemy)
	enemys_l.erase(enm_path)
	prev_enemy = enm_path
	$enemys.add_child(enemy)
	for i in range(0, enemy.combination.size()):
		new_arrow(combination[i])
		if i == show_comb_lenth - 1:
			break
	$enemy_attack.wait_time = enemy.time
	$enemy_attack.start()
	current_enemy = enemy
	$s/ui/name.set_text(enemy.enemy_name)

func new_arrow(tag : String):
	var new_rect = TextureRect.new()
	new_rect.custom_minimum_size = Vector2(90,90)
	var new_path = "res://assets/2d/games/slayer/.png".insert(29, tag)
	new_rect.texture = load(new_path)
	$s/ui/dialog/grid.add_child(new_rect)
