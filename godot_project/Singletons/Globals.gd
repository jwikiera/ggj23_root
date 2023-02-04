extends Node2D


var _console_width: float = 20 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont
var console_font_size = 26
var invite_text = '  ~> '
var seed_ = 'ibib3fi3b'

var grid = []
var grid_size_x = 12
var grid_size_y = 10
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
	#print(console_font.size)

func get_console_width() -> float:
	return get_viewport().size.x / 100 * Globals._console_width
	
func get_x_grid_margin():
	return (get_viewport().size.x - get_console_width()) / 100 * _grid_margin
	
func get_y_grid_margin():
	return get_viewport().size.y / 100 * _grid_margin
	
func get_grid_pos_x():
	var rx = (get_viewport().size.x - get_console_width() - get_x_grid_margin()) / grid_size_x
	var ry = (get_viewport().size.y - get_y_grid_margin()) / grid_size_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
		
	var total_x_len = rx * grid_size_x
	return (get_viewport().size.x - get_console_width() - total_x_len) / 2
	
func get_grid_pos_y():
	var rx = (get_viewport().size.x - get_console_width() - get_x_grid_margin()) / grid_size_x
	var ry = (get_viewport().size.y - get_y_grid_margin()) / grid_size_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
		
	var total_y_len = ry * grid_size_y
	return (get_viewport().size.y - total_y_len) / 2
	
func get_grid_x_cell_size():
	var rx = (get_viewport().size.x - get_console_width() - get_x_grid_margin()) / grid_size_x
	var ry = (get_viewport().size.y - get_y_grid_margin()) / grid_size_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
	return rx
	
func get_grid_y_cell_size():
	var rx = (get_viewport().size.x - get_console_width() - get_x_grid_margin()) / grid_size_x
	var ry = (get_viewport().size.y - get_y_grid_margin()) / grid_size_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
	return ry
	
