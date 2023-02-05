extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Commands.connect("show_credits", self, "_on_show_signal")
	Globals.console.connect("hide_credits", self, "_on_hide_signal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_show_signal():
#	var sprite_height = texture.get_height()
#	var viewport_height = get_viewport().size.y
#	var target_height = viewport_height - viewport_height / 100 * Globals.dialog_margin * 2
#	var ratio: float = target_height / sprite_height
#	scale.x = 1
#	scale.y = 1
#	scale.x *= ratio
#	scale.y *= ratio
#	position.x = (get_viewport().size.x - texture.get_width() * scale.x) / 2
#	position.y = (get_viewport().size.y - texture.get_height() * scale.y) / 2
#	Globals.play_boot()
	visible = true

func _on_hide_signal():
	print('received')
	visible = false
	
