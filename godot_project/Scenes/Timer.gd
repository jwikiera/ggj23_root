extends Label


var blink_timer = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not Globals.timer_enabled:
		blink_timer -= 1
		if blink_timer <= 0:
			blink_timer = 40
			visible = not visible
		
