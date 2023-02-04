extends Node


signal move(direction)
signal change_dir(folder, is_parent)
signal unzip(folder)
signal download(element)

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
	
func command_unzip():
	pass

func command_download():
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null and element.type==Element.Type.CHECKPOINT_FILE:
		Globals.player.add_checkpoint()
		Globals.console.send_log("YELLOW:Checkpoint added")
		element.queue_free()
	elif element!=null and element.type==Element.Type.PASSWORD:
		Globals.player.add_password(element.password_content)
		Globals.console.send_log("YELLOW:Password " + element.password_content + " added")
		element.queue_free()
	elif element!=null and element.type==Element.Type.PRIVILEDGE:
		Globals.player.add_privilege(element.priviledge_level)
		Globals.console.send_log("YELLOW:Privilege added")
		element.queue_free()
	else:
		#pas sur un dossier
		Globals.console.send_log("RED:Not a file")

func command_passwords():
	Globals.console.send_log("YELLOW:Known passwords:")
	for i in range(Globals.player.list_passwords.size()):
		Globals.console.send_log("YELLOW:"+Globals.player.list_passwords[i])
	if Globals.player.list_passwords.size()==0:
		Globals.console.send_log("YELLOW:<No known passwords>")
	
func command_cd():
	#Globals.console.send_log("CD @ (%d, %d)" % [Globals.player_coords.x, Globals.player_coords.y])
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null and element.type==Element.Type.FOLDER:
		if true:#check privilèges
			if true:#check mot de passe
				if true: #zip
					#si ok, changer de folder
					emit_signal("change_dir", element, element==Globals.current_folder.parent)
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
	
	
func command_toggle_cursor():
	Globals.player.toggle_texture()
