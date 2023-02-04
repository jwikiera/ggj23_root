extends Node2D


var _console_width: float = 20 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont
var console_font_size = 26
var invite_text = '  ~> '
var seed_ = 'ibib3fi3b'

var grid = []
var grid_size_x = 30
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
	
func get_grid_end_x():
	return get_grid_pos_x() + get_grid_x_cell_size() * grid_size_x
	
func get_grid_end_y():
	return get_grid_pos_y() + get_grid_y_cell_size() * grid_size_y
	
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
	
func get_physical_coords_of_grid_index(index: Vector2) -> Vector2:
	if (index.x < 0 or index.y < 0 or index.x > grid_size_x - 1 or index.y > grid_size_y - 1):
		print("Error, get_physical_coords_of_grid_index index out of range")
		return Vector2.ZERO
	return Vector2(
		get_grid_pos_x() + index.x * get_grid_x_cell_size(),
		get_grid_pos_y() + index.y * get_grid_y_cell_size()
	)
	
func get_index_from_physical_coords(coords: Vector2) -> Vector2:
	if coords.x > get_grid_end_x() or coords.y > get_grid_end_y() or coords.x < get_grid_pos_x() or coords.y < get_grid_pos_y():
		print("Error: get_index_from_physical_coords index out of range")
		return Vector2.ZERO
	var res_x = 0
	var res_y = 0
	
	for i in range(grid_size_x - 1):
		if coords.x >= get_grid_pos_x() + i * get_grid_x_cell_size():
			res_x = i
	for i in range(grid_size_y - 1):
		if coords.y >= get_grid_pos_y() + i * get_grid_y_cell_size():
			res_y = i
	
	return Vector2(
		res_x,
		res_y
	)
