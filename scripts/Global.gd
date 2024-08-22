extends Node

const GAMEPAD_TOP_BORDER_POS = Vector3(-0.479,0,-0.831)
const GAMEPAD_BOTTOM_BORDER_POS = Vector3(0.479,0,0.335)
var gamepad
var buttons
var minigame
var skip_frames = 1 # только каждый N кадр будет отрисован
var audio = {
	'click' : null,
	'menu' : null,
	'dmg' : null,
	'in_game' : null,
	'clock' : null,
	'zvon' : null
}
var heal = preload("res://scense/heart_in_game.tscn")
var power_ups := [
	preload("res://scense/clock_in_game.tscn"),
	preload("res://scense/score_in_game.tscn"),
	preload("res://scense/shield_in_game.tscn"),
]

var active_btn : Array

func _ready():
	randomize()

func push_button(tag : String):
	gamepad.push(tag)
	active_btn.append(tag)

func leave_button(tag : String):
	gamepad.leave(tag)
	active_btn.erase(tag)

func to_angle(angle : float):
	return angle / 180 * 3.1415926535

func chance(value:float)->bool:
	if randf_range(0,100)<=value: return true
	return false
