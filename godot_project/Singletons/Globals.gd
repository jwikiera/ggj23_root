extends Node2D


var console
var player
var current_folder: Folder


var _console_width: float = 20 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont
var console_font_size = 26
var invite_text = '  ~> '
var seed_ = 'ibib3fi3b'

#var grid = []
#var grid_size_x = 30
#var grid_size_y = 11
var _grid_margin = 10


var COLORS = {
	"RED": Color(1, 0, 0),
	"GREEN": Color(0, 1, 0),
	"YELLOW": Color(1, 1, 0),
	"WHITE": Color(1, 1, 1)
}


func _ready():
	console_font = DynamicFont.new()
	console_font.font_data = load("res://Fonts/Calculator.ttf")
	console_font.size = console_font_size
	console = load("res://Scenes/Console.tscn").instance()
	player = load("res://Player/Player.tscn").instance()
	#print(console_font.size)

func get_console_width() -> float:
	return get_viewport().size.x / 100 * Globals._console_width
	
func get_x_grid_margin():
	return (get_viewport().size.x - get_console_width()) / 100 * _grid_margin
	
func get_y_grid_margin():
	return get_viewport().size.y / 100 * _grid_margin
	
