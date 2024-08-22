extends Control

# LOSE SCREAN

func _on_new_game_pressed():
	G.minigame.start_game()
	G.audio['in_game'].play()
	$lose_screan.hide()


func _on_open_menu_pressed():
	G.audio['menu'].play()
	$lose_screan.hide()
	$main_menu.show()


# MENU

func _on_menu_start_pressed():
	G.minigame.start_game()
	G.audio['in_game'].play()
	G.audio['menu'].stop()
	$main_menu.hide()
