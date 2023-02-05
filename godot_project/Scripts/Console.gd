extends Node2D


var input_node: LineEdit

var message_history = []
var command_history = []
var command_history_index
var tab_hits = []
var tab_hits_life = 0
var tab_hits_index = 0
var tab_hits_index_lifespan = 200

var click_player


# Called when the node enters the scene tree for the first time.
func _ready():
	click_player = load("res://Scenes/keyboard_click.tscn").instance()
	add_child(click_player)
	print(click_player)
	command_history_index = 0
	print("console ready (width %d)" % Globals.get_console_width())
	input_node = get_node("Input")
	input_node.grab_focus()
	input_node.set_position(
		Vector2(get_console_x() + invite_len(),
		get_viewport().size.y - input_node.rect_size.y - 13
		))
	input_node.rect_size.x = Globals.get_console_width()
	#var font = input_node.get_font("Calculator")
	#font.size = Globals.console_font_size
	#input_node.add_font_override("string_name", font)
#	print(Globals.console_font)
#	input_node.theme.set_default_font(Globals.console_font)
#	input_node.theme.set_font("lol", "Dynamic", Globals.console_font)
	input_node.add_font_override("font", Globals.console_font)


func _physics_process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tab_hits_life > 0:
		tab_hits_life -= 1
	else:
		tab_hits = []
	if Input.is_action_just_pressed("tabkey"):
		if len(input_node.text) > 0 and len(tab_hits) == 0:
			var command_keys = []
			for key in Globals.get_commands():
				if Globals.com_enabled(key):
					command_keys.append(key)
			if Globals.com_enabled('move'):
				command_keys += ['move up', 'move down', 'move left', 'move right']
			for key in command_keys:
				if key.begins_with(input_node.text):
					tab_hits.append(key)
			if len(tab_hits) > 0:
				input_node.text = tab_hits[0]
				input_node.caret_position = len(input_node.text)
				tab_hits_life = tab_hits_index_lifespan
		elif len(tab_hits) > 0:
			tab_hits_index += 1
			tab_hits_index = tab_hits_index % len(tab_hits)
			input_node.text = tab_hits[tab_hits_index]
			input_node.caret_position = len(input_node.text)
			tab_hits_life = tab_hits_index_lifespan
	if Input.is_action_just_pressed("console_up"):
		if len(command_history) == 0:
			return
		if command_history_index == -1:
			command_history_index = len(command_history) - 1
		else:
			command_history_index = max(0, command_history_index - 1)
		input_node.text = get_text(command_history[command_history_index])
		input_node.caret_position = len(input_node.text)

		print("pressed up, index: %d" %command_history_index)
	if Input.is_action_just_pressed("console_down"):
		if len(command_history) == 0:
			return
		if command_history_index != -1:
			if command_history_index == len(command_history) - 1:
				input_node.text = ""
				command_history_index = -1
			else:
				command_history_index = min(len(command_history) - 1, command_history_index + 1)
				input_node.text = get_text(command_history[command_history_index])
				input_node.caret_position = len(input_node.text)
		print("pressed down, index: %d" %command_history_index)
	if Input.is_action_just_pressed("caret_left"):
		input_node.caret_position = 0
	if Input.is_action_just_pressed("caret_right"):
		input_node.caret_position = len(input_node.text)
	if Input.is_action_just_pressed("clear_input"):
		input_node.text = ""
	update()

func get_console_x() -> float:
	return get_viewport().size.x - Globals.get_console_width()

func _draw():
	var console_rect = Rect2(
		get_console_x(),
		0,
		Globals.get_console_width(),
		get_viewport().size.y)
	draw_rect(console_rect, Globals.console_color)
	draw_message_history()
	draw_invite()
	#print("we are drawing lol")


func add_to_message_history(message: String):
	message_history.append(message)
	if len(message_history) > 27:
		message_history.remove(0)
		
func add_to_command_history(message: String):
	command_history.append(message)
	if len(command_history) > 10:
		command_history.remove(0)
	add_to_message_history(message)


func _on_Input_text_entered(new_text: String) -> void:
	command_history_index = -1
	#print("Console text entered: %s" % new_text)
	if len(new_text) == 0:
		return
		
	add_to_command_history(new_text)
	
	input_node.clear()
	
	var tlower: String = new_text.to_lower()
	var splitted_tlower = tlower.split(" ")
	#tlower = splitted_tlower[0]
	var info1 = ""
	if splitted_tlower.size()>1:
		info1=splitted_tlower[1]
	
	##################
	# DEBUG COMMANDS #
	##################
	if tlower == "skip":
		Commands.command_skip()
	elif tlower == "all_passwords":
		Commands.command_all_passwords()
	elif tlower == "restart":
		Commands.command_restart()
	elif tlower == "folder":
		Commands.command_get_folder()
	elif tlower == "victory":
		Commands.command_victory()
	elif tlower == "gameover":
		Commands.command_gameover()
	elif tlower == 'shader':
		Commands.command_toggle_shader()
	##################
	# MISC COMMANDS  #
	##################
	elif tlower == "cursor":
		Commands.command_toggle_cursor()
	##################
	# REAL COMMANDS  #
	##################
	elif tlower == "exit" or tlower == ":q":
		Commands.command_exit()
	elif tlower == "move":
		Commands.command_move_incomplete()
	elif tlower == "move up":
		Commands.command_up() 
	elif tlower == "move down":
		Commands.command_down() 
	elif tlower == "move left":
		Commands.command_left() 
	elif tlower == "move right":
		Commands.command_right()
	elif tlower.begins_with("cd"):
		Commands.command_cd(info1)
	elif tlower == "passwords":
		Commands.command_passwords()
	elif tlower == "unzip":
		Commands.command_unzip()
	elif tlower == "download":
		Commands.command_download(info1)
	elif tlower == 'help':
		Commands.command_help()
	elif tlower == 'boot':
		Commands.command_boot()
	elif tlower == 'engage':
		Commands.command_engage()
	else:
		Commands.command_not_available()
		Globals.play_error()


func get_color(command: String) -> Color:
	for key in Globals.COLORS.keys():
		if command.begins_with(key + ':'):
			return Globals.COLORS[key]
	return Color(1, 1, 1)
	
func get_text(command: String) -> String:
	for key in Globals.COLORS.keys():
		if command.begins_with(key + ':'):
			return command.substr(len(key) + 1)
	return command


func draw_message_history():
	var msg_height: float = get_viewport().size.y - input_node.rect_size.y - Globals.console_font.get_height()
	for i in range(len(message_history)):
		var command: String = message_history[len(message_history) - 1 - i]
		draw_string(Globals.console_font, Vector2(get_console_x() + invite_len(), msg_height), get_text(command), get_color(command))
		msg_height -= (Globals.console_font.get_height() + 2)


func invite_len() -> float:
	return Globals.console_font.get_string_size(Globals.invite_text).x

func draw_invite():
	draw_string(Globals.console_font, Vector2(get_console_x(), get_viewport().size.y - Globals.console_font.get_height() / 3), Globals.invite_text)
	
func send_log(log_text: String, play_sound=true):
	if play_sound:
		Globals.play_message()
	var color = ""
	for key in Globals.COLORS.keys():
		if log_text.begins_with(key + ':'):
			color = key + ':'
	log_text = get_text(log_text)
	var messages = log_text.split('\n')
	for msg in messages:
		add_to_message_history(color + msg)
		
func send_error(log_text: String):
	Globals.play_error()
	add_to_message_history("RED:" + log_text)

		
func _on_Input_gui_input(inp: InputEventKey):
	if inp.is_pressed() and inp.as_text().to_lower() in ['backspace', 'enter']:
		click_player.play()
	if inp.is_pressed() and len(inp.as_text()) == 1:
		click_player.play()
		#print(ord(inp.as_text().to_lower()))
		var key = ord(inp.as_text().to_lower())
		if key >= 97 and key <= 122 or key >= 48 and key <= 57:
			tab_hits = []
			
func clear_history():
	message_history.clear()
