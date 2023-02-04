extends Node

func get_grid_pos_x(folder: Folder):
	var rx = (get_viewport().size.x - Globals.get_console_width() - Globals.get_x_grid_margin()) / folder.cell_amount_x
	var ry = (get_viewport().size.y - Globals.get_y_grid_margin()) / folder.cell_amount_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
		
	var total_x_len = rx * folder.cell_amount_x
	return (get_viewport().size.x - Globals.get_console_width() - total_x_len) / 2
	
func get_grid_pos_y(folder: Folder):
	var rx = (get_viewport().size.x - Globals.get_console_width() - Globals.get_x_grid_margin()) / folder.cell_amount_x
	var ry = (get_viewport().size.y - Globals.get_y_grid_margin()) / folder.cell_amount_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
		
	var total_y_len = ry * folder.cell_amount_y
	return (get_viewport().size.y - total_y_len) / 2
	
func get_grid_end_x(folder: Folder):
	return get_grid_pos_x(folder) + get_grid_x_cell_size(folder) * folder.cell_amount_x
	
func get_grid_end_y(folder: Folder):
	return get_grid_pos_y(folder) + get_grid_y_cell_size(folder) * folder.cell_amount_y
	
func get_grid_x_cell_size(folder: Folder):
	var rx = (get_viewport().size.x - Globals.get_console_width() - Globals.get_x_grid_margin()) / folder.cell_amount_x
	var ry = (get_viewport().size.y - Globals.get_y_grid_margin()) / folder.cell_amount_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
	return rx
	
func get_grid_y_cell_size(folder: Folder):
	var rx = (get_viewport().size.x - Globals.get_console_width() - Globals.get_x_grid_margin()) / folder.cell_amount_x
	var ry = (get_viewport().size.y - Globals.get_y_grid_margin()) / folder.cell_amount_y
	if rx < ry:
		ry = rx
	else:
		rx = ry
	return ry
	
func get_physical_coords_of_grid_index(folder: Folder, index: Vector2) -> Vector2:
	if (index.x < 0 or index.y < 0 or index.x > folder.cell_amount_x - 1 or index.y > folder.cell_amount_y - 1):
		print("Error, get_physical_coords_of_grid_index index out of range")
		return Vector2.ZERO
	return Vector2(
		get_grid_pos_x(folder) + index.x * get_grid_x_cell_size(folder),
		get_grid_pos_y(folder) + index.y * get_grid_y_cell_size(folder)
	)
	
func get_index_from_physical_coords(folder: Folder, coords: Vector2) -> Vector2:
	if coords.x > get_grid_end_x(folder) or coords.y > get_grid_end_y(folder) or coords.x < get_grid_pos_x(folder) or coords.y < get_grid_pos_y(folder):
		print("Error: get_index_from_physical_coords index out of range")
		return Vector2.ZERO
#	var res_x = 0
#	var res_y = 0
#
#	for i in range(grid_size_x - 1):
#		if coords.x >= get_grid_pos_x() + i * get_grid_x_cell_size():
#			res_x = i
#	for i in range(grid_size_y - 1):
#		if coords.y >= get_grid_pos_y() + i * get_grid_y_cell_size():
#			res_y = i
	
	return Vector2(
		int(floor((coords.x - get_grid_pos_x(folder)) / get_grid_x_cell_size(folder))) - 1,
		int(floor((coords.y - get_grid_pos_y(folder)) / get_grid_y_cell_size(folder))) - 1
	)
