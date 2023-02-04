extends Node


signal move(direction)
signal change_dir(folder)

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
	
func command_cd():
	Globals.console.send_log("CD @ (%d, %d)" % [Globals.player_coords.x, Globals.player_coords.y])
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)
	if element!=null and element.type==Element.Type.FOLDER:
		if true:#check privilèges
			if true:#check mot de passe
				if true: #zip
					#si ok, changer de folder
					emit_signal("change_dir", element.parent)
					Globals.console.send_log("YELLOW:Changed directory")
				else:
					Globals.console.send_log("YELLOW:Unzip before accessing")
			else:
				Globals.console.send_log("RED:Password required")
		else:
			Globals.console.send_log("RED:Access denied")
			Globals.console.send_log("RED:Higher privileges required")
	else:
		#pas sur un dossier
		Globals.console.send_log("YELLOW:Not a directory")
	#check si on peut l'ouvrir
	
	
func command_toggle_cursor():
	Globals.player.toggle_texture()
