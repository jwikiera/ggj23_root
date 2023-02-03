extends Node2D

# Grid variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var folder_amount

var grid = []

func _ready():
	grid = make_2d_array(width, height)
	print(grid)

func make_2d_array(width, height):
	var array = []
	for j in width:
		array.append([])
		for i in height:
			array[j].append(1)
	return (array)

#func fill_grid(grid):
