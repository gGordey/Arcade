extends Node3D

@onready var games_list = {
	'snake' : preload("res://scense/minigames/snake.tscn"),
	'flappy bird' : preload("res://scense/minigames/flappy_bird.tscn"),
	'pointNclick' : preload("res://scense/minigames/pointNclick/pointNclicktscn.tscn"),
	'slayer' : preload("res://scense/minigames/slayer/slayer.tscn"),
	'driver' : preload("res://scense/minigames/driver/driver.tscn"),
	'shootan' : preload("res://scense/minigames/shootan/shootan.tscn"),
}
var game_names = ['shootan','shootan']#['snake','flappy bird','slayer','driver']
var active_minigame := ''
var last_minigame
var is_losed : bool
var game
var mini_score : int
var score : int
var shield : bool
var game_time := 15
var max_hp := 4
var hp := 4

func change_minigame(minigame : String):
	if hp <= 0: return
	if game && mini_score == 0: take_dmg(); return
	if last_minigame: game_names.append(last_minigame)
	#if shield: 
	#	shield = false
	#	$"../hearts".del_shield()
	mini_score = 0
	var new_game = games_list[minigame].instantiate()
	active_minigame = minigame
	last_minigame = active_minigame
	game_names.erase(minigame)
	add_child(new_game)
	game = new_game
	game.start_game()
	$game_timer.start()
	$"../../ui/in_game/next_game_timer".max_value = game_time
	$"../../ui/in_game/next_game_timer".value = game_time
	for i in range(0,G.active_btn.size()):
		G.leave_button(G.active_btn[i])

func _ready():
	$game_timer.wait_time = game_time
	G.minigame = self
	$"../hearts".heart_count = hp

func _physics_process(delta):
	if !game: return
	if $game_timer.time_left < 5 && !G.audio['clock'].playing && hp: G.audio['clock'].play()
	if $lose_timer.is_stopped() && is_losed:
		end_minigame(1)
		is_losed = false
	if game.is_game_in_progress:
		$"../../ui/in_game/next_game_timer".value = $game_timer.time_left

func start_game():
	if game: end_minigame(1)
	hp = max_hp
	$"../../ui/in_game".show()
	change_score(0)
	active_minigame = ''
	last_minigame = ''
	$game_timer.stop()
	$"../hearts".heart_count = hp
	$"../hearts".fill_hearts()
	mini_score = 1
	change_minigame(game_names[randi_range(0, game_names.size()-1)])

func moment_click(tag : String):
	if game && game.has_method('click_control'):
		game.click_control(tag)

func lose():
	end_minigame(0)
	G.audio['in_game'].stop()
	game_names.append(last_minigame)
	$"../../ui/lose_screan/final_score".set_text('Final Score : ' + str(score))
	$"../../ui/lose_screan".show()
	change_score(0)

func end_minigame(is_free:bool):
	G.audio['clock'].playing = false
	game.is_game_in_progress = false
	$game_timer.stop()
	if is_free: game.queue_free()
	if hp>0: change_minigame(game_names[randi_range(0, game_names.size()-1)])

func win():
	change_score(0)
	game.is_game_in_progress = false

func add_score(reward : int):
	score += reward
	mini_score += reward
	$"../../ui/in_game/scores/main_score".set_text('SCORE ' + str(score))

func change_score(num : int):
	score = num
	$"../../ui/in_game/scores/main_score".set_text('SCORE ' + str(score))

func take_dmg():
	if !game.is_game_in_progress: return
	G.audio['dmg'].play()
	if !shield: hp-=1
	else: shield=false
	$"../hearts".del_heart()
	#if hp<0: hp = 0
	if hp == 0: 
		lose()
		return
	mini_score = 1
	$lose_timer.start()
	is_losed = true
	game.is_game_in_progress = false
	#end_minigame()

func heal():
	if shield: $"../hearts".del_shield()
	if hp<max_hp:
		hp+=1
		$"../hearts".add_heart(hp)
	if shield: $"../hearts".add_shield()

func add_time(amound:float):
	G.audio['clock'].stop()
	if $game_timer.time_left+amound<15:
		$game_timer.wait_time = $game_timer.time_left+amound
	else:
		$game_timer.wait_time = 15
	$game_timer.start()
	$game_timer.wait_time = 15

func take_shield():
	shield = true
	$"../hearts".add_shield()

func _on_game_timer_timeout():
	G.audio['zvon'].play()
	if !mini_score:
		take_dmg()
	else:
		end_minigame(1)
	$game_timer.start()
