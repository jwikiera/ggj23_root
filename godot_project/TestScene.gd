extends Node2D


var player_node


# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = get_node("Player")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
