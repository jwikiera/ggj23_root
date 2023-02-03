extends Node2D

# Grid variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start

var grid = []

func _ready():
	grid = make_2d_array()
	print(grid)

func make_2d_array():
	var array = []
	for j in width:
		array.append([])
		for i in height:
			array[j].append(0)
	return (array)
