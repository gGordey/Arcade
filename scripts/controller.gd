extends CharacterBody3D

@onready var buttons = {
	'up' : $buttons/UpButton,
	'down' : $buttons/DownButton,
	'left' : $buttons/LeftButton,
	'right' : $buttons/RightButton,
	'act' : $buttons/ActButton,
}

func _ready():
	G.gamepad = self

func push(tag : String):
	buttons[tag].position.y =- 0.05 #buttons[tag].position.y -= 0.05

func leave(tag : String):
	buttons[tag].position.y = 0
