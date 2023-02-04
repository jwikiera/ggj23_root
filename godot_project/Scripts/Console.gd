extends Node2D


var input_node: LineEdit

var command_history = []
var command_history_index


# Called when the node enters the scene tree for the first time.
func _ready():
	command_history_index = 0
	print("console ready (width %d)" % Globals.get_console_width())
	input_node = get_node("Input")
	input_node.grab_focus()
	input_node.set_position(
		Vector2(get_console_x() + invite_len(),
		get_viewport().size.y - input_node.rect_size.y - 13
		))
	input_node.rect_size.x = Globals.get_console_width()
	var font = input_node.get_font("Calculator")
	font.size = 25 #Globals.console_font_size
	input_node.add_font_override("string_name", font)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("console_up"):
		if len(command_history) == 0:
			return
		if command_history_index == -1:
			command_history_index = len(command_history) - 1
		else:
			command_history_index = max(0, command_history_index - 1)
		input_node.text = get_text(command_history[command_history_index])
		input_node.caret_position = len(input_node.text)

		print("pressed up, index: %d" %command_history_index)
	if Input.is_action_just_released("console_down"):
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
	draw_console_history()
	draw_invite()
	#print("we are drawing lol")


func _on_Input_text_entered(new_text: String) -> void:
	command_history_index = -1
	print("Console text entered: %s" % new_text)
	if len(new_text) == 0:
		return
	input_node.clear()
	
	var tlower: String = new_text.to_lower()
	
	if tlower == "exit":
		Commands.command_exit()
	elif tlower == "move up":
		Commands.command_up() 
	elif tlower == "move down":
		Commands.command_down() 
	elif tlower == "move left":
		Commands.command_left() 
	elif tlower == "move right":
		Commands.command_right() 
		
	if new_text.begins_with('l'):
		command_history.append("RED:" + new_text)
	elif new_text.begins_with('a'):
		command_history.append("GREEN:" + new_text)
	else:
		command_history.append(new_text)

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


func draw_console_history():
	var command_height: float = get_viewport().size.y - input_node.rect_size.y - Globals.console_font.get_height()
	for i in range(len(command_history)):
		var command: String = command_history[len(command_history) - 1 - i]
		draw_string(Globals.console_font, Vector2(get_console_x() + invite_len(), command_height), get_text(command), get_color(command))
		command_height -= (Globals.console_font.get_height() + 2)


func invite_len() -> float:
	return Globals.console_font.get_string_size(Globals.invite_text).x

func draw_invite():
	draw_string(Globals.console_font, Vector2(get_console_x(), get_viewport().size.y - Globals.console_font.get_height() / 2), Globals.invite_text)
