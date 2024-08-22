extends Node

func _ready():
	G.audio['click'] = $audio/click
	G.audio['menu'] = $audio/menu
	G.audio['dmg'] = $audio/dmg
	G.audio['in_game'] = $audio/in_game
	G.audio['clock'] = $audio/tic_tac
	G.audio['zvon'] = $audio/zvon
