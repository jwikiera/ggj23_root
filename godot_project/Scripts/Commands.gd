extends Node


signal move(direction)
signal change_dir(folder, is_parent, password)
signal unzip(folder)
signal download(element)
signal start_game()
signal toggle_shader()
signal restart()

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
	Globals.console.send_error("Command not found or unavailable")

func command_exit():
	print("Command exit")
	get_tree().quit()

func _send_move_signal(direction: int):
	emit_signal("move", direction)

func command_move_incomplete():
	if not Globals.com_enabled('move'):
		command_not_available()
		return
	Globals.console.send_error("Missing argument")

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

func command_download(password):
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null:
		if Globals.player.priviledge_level>=element.protection_level:#check privilèges:
			if element.password_access=="" or Globals.passwords_dictionnary[element.password_access]==password.to_upper():#check mot de passe
				if true: #zip
					#si ok, changer de folder
					if element.type==Element.Type.CHECKPOINT_FILE:
						Globals.player.add_checkpoint()
						Globals.console.send_log("YELLOW:Checkpoint added")
						element.delete()
					elif element.type==Element.Type.PASSWORD:
						Globals.player.add_password(element.password_content)
						Globals.console.send_log("YELLOW:Password '" + Globals.passwords_dictionnary[element.password_content] + "' added")
						element.delete()
					elif element.type==Element.Type.PRIVILEDGE:
						Globals.player.add_privilege(element.priviledge_level)
						Globals.console.send_log("YELLOW:Privilege added")
						element.delete()
					elif element.type==Element.Type.TUTO:
						if element.command!='':
							Globals.console.send_log("YELLOW:New command learned: "+element.command)
							Globals.enable_command(element.command)
						if element.explanation!="":
							Globals.console.send_log("CYAN:"+element.explanation)
						element.delete()
					elif element.type==Element.Type.SABLIER:
						Globals.console.send_log("YELLOW:"+str(element.additionnal_time)+" seconds added")
						Globals.timer_principal += element.additionnal_time
						element.delete()
					else:
						#pas sur un dossier
						Globals.console.send_error("Not a file")
						Globals.play_error()
				else:
					Globals.console.send_log("YELLOW:Unzip before accessing")
					Globals.play_error()
			elif password=="":
				Globals.console.send_error("Password required")
				Globals.play_error()
			else:
				Globals.console.send_error("Password incorrect")
				Globals.play_error()
				
				
			
		else:
			Globals.console.send_error("Access denied")
			Globals.console.send_error("Higher privileges required")
			Globals.play_error()
			
	else:
		#pas sur un dossier
		Globals.console.send_error("Not a file")
		Globals.play_error()

func command_passwords():
	Globals.console.send_log("YELLOW:Known passwords:")
	for i in range(Globals.player.list_passwords.size()):
		Globals.console.send_log("YELLOW:"+Globals.passwords_dictionnary[Globals.player.list_passwords[i]])
	if Globals.player.list_passwords.size()==0:
		Globals.console.send_log("YELLOW:<No known passwords>")

func command_all_passwords():
	Globals.console.send_log("YELLOW:Known passwords:")
	for i in range(Globals.passwords_dictionnary.keys().size()):
		Globals.console.send_log("YELLOW:"+Globals.passwords_dictionnary[Globals.passwords_dictionnary.keys()[i]])

func command_cd(password:String):
	if not Globals.com_enabled('cd'):
		command_not_available()
		return
	#Globals.console.send_log("CD @ (%d, %d)" % [Globals.player_coords.x, Globals.player_coords.y])
	#check s'il y a un dossier à la pos du joueur
	var element = Globals.current_folder.getElement(Globals.player_coords)

	if element!=null and element.type==Element.Type.FOLDER:
		if Globals.player.priviledge_level>=element.protection_level:#check privilèges
#			print("1." + element.password_access)
#			if element.password_access!="":
#				print("2." + Globals.passwords_dictionnary[element.password_access])
#			print("3." + password)
			if element.password_access=="" or Globals.passwords_dictionnary[element.password_access]==password.to_upper():#check mot de passe
				if true: #zip
					#si ok, changer de folder
					emit_signal("change_dir", element, element==Globals.current_folder.parent)
					Globals.console.send_log("YELLOW:Changed directory", false)
					Globals.play_chdir()
				else:
					Globals.console.send_log("YELLOW:Unzip before accessing")
			elif password=="":
				Globals.console.send_error("Password required")
			else:
				Globals.console.send_error("Password incorrect")
		else:
			Globals.console.send_error("Access denied")
			Globals.console.send_error("Higher privileges required")
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
	Globals.play_boot()
	Globals.console.send_log('Seed estimate %d' % Globals.seed_)
	yield(get_tree().create_timer(0.7), "timeout")
	Globals.console.send_log('Init complete')
	Globals.enable_command('engage')
	
func enable_base_commands():
	Globals.enable_command('cd')
	Globals.enable_command('move')
	Globals.enable_command('download')
	Globals.enable_command('restart')

func command_engage():
	if not Globals.com_enabled('engage'):
		command_not_available()
		return
	Globals.disable_command('engage')
	yield(get_tree().create_timer(0.2), "timeout")
	Globals.play_engage()
	Globals.console.send_log('...')
	yield(get_tree().create_timer(0.4), "timeout")
	Globals.console.send_log('Connection with sytem established')
	enable_base_commands()
	emit_signal("start_game")
	
func command_toggle_shader():
	emit_signal("toggle_shader")

func command_skip():
	Globals.disable_command('engage')
	
	enable_base_commands()
	if not Globals.game_has_started:
		emit_signal("start_game")

func command_help():
	var res = 'List of commands:'
	for command in Globals.get_commands():
		if Globals.com_enabled(command):
			res += '\n   * ' + Globals._commands[command]['full_name']
	Globals.console.send_log(res)
	
func command_restart():
	if not Globals.com_enabled('restart'):
		command_not_available()
		return
	emit_signal("restart")

func command_victory():
	Globals.victory()

func command_gameover():
	Globals.game_over()

func command_aezakmi():
	Globals.timer_enabled = false
	Globals.play_aezakmi()
	
func command_iamspeed():
	Globals.numpad_moves = true
