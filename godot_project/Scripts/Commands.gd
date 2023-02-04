extends Node


signal move(direction)
signal change_dir(folder, is_parent, password)
signal unzip(folder)
signal download(element)
signal start_game()
signal toggle_shader()

const DIRS = {
	DIR_UP = 0,
	DIR_DOWN = 1,
	DIR_LEFT = 2,
	DIR_RIGHT = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func command_not_available():
	Globals.console.send_log("RED:Command not found or unavailable")

func command_exit():
	print("Command exit")
	get_tree().quit()

func _send_move_signal(direction: int):
	emit_signal("move", direction)

func command_move_incomplete():
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	Globals.console.send_log("RED:Missing argument")

func command_up():
	print('doing command up')
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	_send_move_signal(DIRS.DIR_UP)
	
func command_down():
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	_send_move_signal(DIRS.DIR_DOWN)
	
func command_left():
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	_send_move_signal(DIRS.DIR_LEFT)
	
func command_right():
	#print('lolololo')
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	_send_move_signal(DIRS.DIR_RIGHT)
	
func command_unzip():
	pass

func command_download():
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null and element.type==Element.Type.CHECKPOINT_FILE:
		Globals.player.add_checkpoint()
		Globals.console.send_log("YELLOW:Checkpoint added")
		element.delete()
	elif element!=null and element.type==Element.Type.PASSWORD:
		Globals.player.add_password(element.password_content)
		Globals.console.send_log("YELLOW:Password " + Globals.passwords_dictionnary[element.password_content] + " added")
		element.delete()
	elif element!=null and element.type==Element.Type.PRIVILEDGE:
		Globals.player.add_privilege(element.priviledge_level)
		Globals.console.send_log("YELLOW:Privilege added")
		element.delete()
	else:
		#pas sur un dossier
		Globals.console.send_log("RED:Not a file")

func command_passwords():
	Globals.console.send_log("YELLOW:Known passwords:")
	for i in range(Globals.player.list_passwords.size()):
		Globals.console.send_log("YELLOW:"+Globals.passwords_dictionnary[Globals.player.list_passwords[i]])
	if Globals.player.list_passwords.size()==0:
		Globals.console.send_log("YELLOW:<No known passwords>")
	

func command_cd(password:String):
	if not Globals.com_enabled('cd'):
		command_not_available()
		return
	#Globals.console.send_log("CD @ (%d, %d)" % [Globals.player_coords.x, Globals.player_coords.y])
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null and element.type==Element.Type.FOLDER:
		if true:#check privilèges
#			print("1." + element.password_access)
#			if element.password_access!="":
#				print("2." + Globals.passwords_dictionnary[element.password_access])
#			print("3." + password)
			if element.password_access=="" or Globals.passwords_dictionnary[element.password_access]==password.to_upper():#check mot de passe
				if true: #zip
					#si ok, changer de folder
					emit_signal("change_dir", element, element==Globals.current_folder.parent)
					Globals.console.send_log("YELLOW:Changed directory")
				else:
					Globals.console.send_log("YELLOW:Unzip before accessing")
			elif password=="":
				Globals.console.send_log("RED:Password required")
			else:
				Globals.console.send_log("RED:Password incorrect")
		else:
			Globals.console.send_log("RED:Access denied")
			Globals.console.send_log("RED:Higher privileges required")
	else:
		#pas sur un dossier
		Globals.console.send_log("YELLOW:Not a directory")
	
func command_get_folder():
	Globals.console.send_log("YELLOW:"+Globals.current_folder.name_element)
	print("Folder : " +Globals.current_folder.name_element)
	
func command_toggle_cursor():
	Globals.player.toggle_texture()
	
func command_boot():
	if not Globals.com_enabled('boot'):
		command_not_available()
		return
	if not Globals.has_greeted:
		Globals.console.send_log("You know what this is about, don't you?")
		Globals.has_greeted = true
	Globals.disable_command('boot')
	yield(get_tree().create_timer(1.0), "timeout")
	Globals.console.send_log('...')
	yield(get_tree().create_timer(0.5), "timeout")
	Globals.console.send_log('Booting main system')
	yield(get_tree().create_timer(0.3), "timeout")
	Globals.console.send_log('Seed estimate %d' % Globals.seed_)
	yield(get_tree().create_timer(0.7), "timeout")
	Globals.console.send_log('Init complete')
	Globals.enable_command('engage')
	
func command_engage():
	if not Globals.com_enabled('engage'):
		command_not_available()
		return
	Globals.disable_command('engage')
	yield(get_tree().create_timer(0.2), "timeout")
	Globals.console.send_log('...')
	yield(get_tree().create_timer(0.4), "timeout")
	Globals.console.send_log('Connection with sytem established')
	Globals.enable_command('cd')
	Globals.enable_command('move')
	emit_signal("start_game")
	
func command_toggle_shader():
	emit_signal("toggle_shader")

func command_help():
	var res = 'List of commands:'
	for command in Globals.get_commands():
		if Globals.com_enabled(command):
			res += '\n   * ' + command
	Globals.console.send_log(res)
