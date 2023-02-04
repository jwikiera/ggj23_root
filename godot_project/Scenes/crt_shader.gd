extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#Commands.connect("toggle_shader", self, "_toggle_shader_signal_received")
	Commands.connect("toggle_shader", self, "_toggle_shader_signal_received")
	
func _toggle_shader_signal_received():
	self.visible = !self.visible
