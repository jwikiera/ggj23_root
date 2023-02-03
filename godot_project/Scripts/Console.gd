extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("console ready (width %d)" % Singleton.console_width) # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	var wdth: float = get_viewport().size.x - get_viewport().size.x / 100 * Singleton.console_width
	var console_rect = Rect2(
		get_viewport().size.x - wdth,
		0,
		get_viewport().size.x,
		get_viewport().size.y)
	draw_rect(console_rect, Color(0, 0, 0))
	#print("we are drawing lol")
