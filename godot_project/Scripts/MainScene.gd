extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	var console_ = load("res://Scenes/Console.tscn")
#	var console = console_.instance()
#
	
	var folder_ = load("res://Elements/Folder.tscn")
	var folder = folder_.instance()
	get_tree().change_scene_to(folder_)
	
	
#	var console = load("res://Scenes/Console.tscn").instance()
#	var folder = load("res://Elements/Folder.tscn").instance()
#	folder.add_child(console)
#	get_tree().root.add_child(folder)
#	get_tree().change_scene_to(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
