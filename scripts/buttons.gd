extends Control


func _ready():
	G.buttons = self

func click(tag : String):
	G.push_button(tag)
	G.minigame.moment_click(tag)
	G.audio['click'].play()
func unclick(tag : String):
	G.leave_button(tag)

func _on_up_button_down():
	click('up')
func _on_up_button_up():
	unclick('up')


func _on_down_button_down():
	click('down')
func _on_down_button_up():
	unclick('down')


func _on_right_button_down():
	click('right')
func _on_right_button_up():
	unclick('right')


func _on_left_button_down():
	click('left')
func _on_left_button_up():
	unclick('left')


func _on_act_button_down():
	click('act')
func _on_act_button_up():
	unclick('act')

func _physics_process(_delta):
	if Input.is_action_just_pressed('left'):
		click('left')
	if Input.is_action_just_released('left'):
		unclick('left')
	
	if Input.is_action_just_pressed('right'):
		click('right')
	if Input.is_action_just_released('right'):
		unclick('right')
	
	if Input.is_action_just_pressed('up'):
		click('up')
	if Input.is_action_just_released('up'):
		unclick('up')
	
	if Input.is_action_just_pressed('down'):
		click('down')
	if Input.is_action_just_released('down'):
		unclick('down')
	
	if Input.is_action_just_pressed('act'):
		click('act')
	if Input.is_action_just_released('act'):
		unclick('act')
