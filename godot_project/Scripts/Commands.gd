extends Node


signal move(direction)

const DIRS = {
	DIR_UP = 0,
	DIR_DOWN = 1,
	DIR_LEFT = 2,
	DIR_RIGHT = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func command_exit():
	print("Command exit")
	get_tree().quit()

func _send_move_signal(direction: int):
	emit_signal("move", direction)
	
func command_up():
	_send_move_signal(DIRS.DIR_UP)
	
func command_down():
	_send_move_signal(DIRS.DIR_DOWN)
	
func command_left():
	_send_move_signal(DIRS.DIR_LEFT)
	
func command_right():
	_send_move_signal(DIRS.DIR_RIGHT)
