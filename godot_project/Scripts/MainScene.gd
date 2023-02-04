extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MainScene ready")
	seed(2023)
	
	Commands.connect("move", self, "_on_move_signal")
	Commands.connect("change_dir", self, "_on_change_dir_signal")

	#var folder_ = load("res://Elements/Folder.tscn")
	#var folder = folder_.instance()
	Globals.current_folder.initialize_scene(self)
	add_child(Globals.console)
	add_child(Globals.player)
	
	Globals.player_coords = Vector2(int(Globals.current_folder.cell_amount_x / 2), int(Globals.current_folder.cell_amount_y / 2))
	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	GridUtils.scale_sprite_node(Globals.player.get_node("Sprite"), Globals.current_folder)
	GridUtils.compensate_scale_pos(Globals.player.get_node("Sprite"), Globals.current_folder)
	

func _process(delta):
	update()


###########################
# CHANGEMENT DE FOLDER
###########################

func _on_change_dir_signal(new_folder:Folder, is_parent:bool):
	Globals.console.send_log("received cd signal")
	#placer joueur au bon endroit (étape 1)
	if is_parent:
		Globals.player_coords = Globals.current_folder.position_grid
	else:
		Globals.player_coords = Globals.current_folder.position_grid_parent
		
	# retirer les anciens elements et placer les nouveaux
	Globals.current_folder.delete_scene(self)
	Globals.current_folder=new_folder
	Globals.current_folder.initialize_scene(self)
	
	#placer joueur au bon endroit (étape 2 et fin)
	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))


###########################
# MOVE
###########################

func _on_move_signal(direction: int) -> void:
	if direction == Commands.DIRS.DIR_UP:
		if Globals.player_coords.y == 0:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			Globals.player_coords.y -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_DOWN:
		if Globals.player_coords.y == Globals.current_folder.cell_amount_y - 1:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			Globals.player_coords.y += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_LEFT:
		if Globals.player_coords.x == 0:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			Globals.player_coords.x -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_RIGHT:
		if Globals.player_coords.x == Globals.current_folder.cell_amount_x - 1:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			Globals.player_coords.x += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))


###########################
# DRAWING
###########################

func _draw():
	draw_grid_lines()
	#draw_rect_at_index(Globals.current_folder, Vector2(0, 0))
	#draw_rect_at_index(Globals.current_folder, Vector2(5, 13))
	
	
func draw_rect_at_index(folder: Folder, index: Vector2) -> void:
	var pos = GridUtils.get_physical_coords_of_grid_index(folder, index)
	draw_rect(
		Rect2(
			pos.x,
			pos.y,
			10,
			10	
		),
		Color(1, 0, 1)
	)

	
func draw_grid_lines():
	var x_size: float = GridUtils.get_grid_x_cell_size(Globals.current_folder)
	var y_size: float = GridUtils.get_grid_y_cell_size(Globals.current_folder)
	
	var i: int = 0 # y	
	while i < Globals.current_folder.cell_amount_y + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder), GridUtils.get_grid_pos_y(Globals.current_folder) + i * y_size),
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + Globals.current_folder.cell_amount_x * x_size, GridUtils.get_grid_pos_y(Globals.current_folder) + i * y_size),
			Globals.COLORS['WHITE']
		)
		i += 1
		
	var j: int = 0 # x
	while j < Globals.current_folder.cell_amount_x + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + j * x_size, GridUtils.get_grid_pos_y(Globals.current_folder)),
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + j * x_size, GridUtils.get_grid_pos_y(Globals.current_folder) + Globals.current_folder.cell_amount_y * y_size),
			Globals.COLORS['WHITE']
		)
		j += 1


