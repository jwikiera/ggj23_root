extends Node2D

var _cell_scene

func _ready():
	_cell_scene = load("res://Grid/Cell.tscn")
	init_grid()
	#print_grid_debug()
	
func _draw():
	draw_grid_lines()

#func fill_grid(grid):

func _process(delta):
	update()


func init_grid():
	for i in range(Globals.grid_size_y):
		Globals.grid.append([])
		for j in range(Globals.grid_size_x):
			var cell = _cell_scene.instance()
			add_child(cell)
			Globals.grid[i].append(cell)
			
func print_grid_debug():
	for i in range(Globals.grid_size_y):
		for j in range(Globals.grid_size_x):
			print(Globals.grid[i][j])

func draw_grid_lines():
	var x_size: float = Globals.get_grid_x_cell_size()
	var y_size: float = Globals.get_grid_y_cell_size()
	
	var i: int = 0 # y	
	while i < Globals.grid_size_y + 1:
		draw_line(
			Vector2(Globals.get_grid_pos_x(), Globals.get_grid_pos_y() + i * y_size),
			Vector2(Globals.get_grid_pos_x() + Globals.grid_size_x * x_size, Globals.get_grid_pos_y() + i * y_size),
			Globals.COLORS['WHITE']
		)
		i += 1
		
	var j: int = 0 # x
	while j < Globals.grid_size_x + 1:
		draw_line(
			Vector2(Globals.get_grid_pos_x() + j * x_size, Globals.get_grid_pos_y()),
			Vector2(Globals.get_grid_pos_x() + j * x_size, Globals.get_grid_pos_y() + Globals.grid_size_y * y_size),
			Globals.COLORS['WHITE']
		)
		j += 1
	
#	for i in range(Globals.grid_size_y):
#		for j in range(Globals.grid_size_x):
#			draw_line(Vector2(j * x_size, i * y_size), Vector2(Globals.grid_size_x * x_size, i * y_size))
#			draw_line(Vector2(j * x_size, i * y_size), Vector2(j * x_size, Globals.grid_size_y *))
