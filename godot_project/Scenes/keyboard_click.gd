extends AudioStreamPlayer


var last_pitch = 1.0


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


func play(from_position=0.0):
	#print('bruhhhh')
	#randomize()
	pitch_scale = rand_range(0.9, 1.3)
	
	while abs(pitch_scale - last_pitch) < 0.1:
		pitch_scale = rand_range(0.9, 1.3)
	
	.play(from_position)

