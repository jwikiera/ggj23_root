extends Node2D


var console_width: float
var console_x: float
var input_node: LineEdit

var command_history = []

# Called when the node enters the scene tree for the first time.
func _ready():
	console_width = get_viewport().size.x / 100 * Singleton.console_width
	console_x = get_viewport().size.x - console_width
	print("console ready (width %d)" % Singleton.console_width)
	input_node = get_node("Input")
	input_node.grab_focus()
	input_node.set_position(Vector2(console_x, get_viewport().size.y - input_node.rect_size.y))
	input_node.rect_size.x = console_width


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	var console_rect = Rect2(
		console_x,
		0,
		console_width,
		get_viewport().size.y)
	draw_rect(console_rect, Singleton.console_color)
	draw_console_history()
	#print("we are drawing lol")


func _on_Input_text_entered(new_text: String) -> void:
	print("Console text entered: %s" % new_text)
	if len(new_text) == 0:
		return
	input_node.clear()
	
	command_history.append(new_text)
	
	if new_text.to_lower() == "exit":
		Commands.command_exit()


func draw_console_history():
	var command_height: float = get_viewport().size.y - input_node.rect_size.y - Singleton.console_font.get_height()
	for i in range(len(command_history)):
		draw_string(Singleton.console_font, Vector2(console_x, command_height), command_history[len(command_history) - 1 - i])
		command_height -= (Singleton.console_font.get_height() + 2)
