extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	var folder_ = load("res://Elements/Folder.tscn")
	#var folder = folder_.instance()
	#Globals.current_folder = folder_
	get_tree().change_scene_to(folder_)

