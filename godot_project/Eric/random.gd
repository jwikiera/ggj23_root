extends Node

func _ready():
	var random_pos = get_random_pos(8, 8, 3)
	print(random_pos)
	
func get_random_pos(width, height, amount):
	var random_pos = [(randi() % width, randi() % height) for i in range(amount)]
	return random_pos
