extends Node2D


var console_width: float
var console_x: float
var input_node: LineEdit

var command_history = ["test", "lalalalallala", "hello world"]

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
	#print("we are drawing lol")


func _on_Input_text_entered(new_text: String) -> void:
	print("Console text entered: %s" % new_text)
	input_node.clear()
	
	if new_text.to_lower() == "exit":
		Commands.command_exit()
