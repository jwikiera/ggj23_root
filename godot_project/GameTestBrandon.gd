extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			var root = Folder.new()
			root.Initialize(null, Vector2(0,0), Element.Type.FOLDER, Element.Protection.ROUGE, "password1")
			generate(root)
			root.print()
			root.initialize_scene(self)

