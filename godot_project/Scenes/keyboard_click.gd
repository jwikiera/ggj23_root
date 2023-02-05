extends AudioStreamPlayer


var last_pitch = 1.0
var sounds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1, 10):
		var name: String = "res://Assets/Audio/Sounds/hit_keys/hit_key" + str(i) +".wav"
		sounds.append(load(name))
	#print(sounds)
	stream = sounds[0]


func play(from_position=0.0):
	stream = sounds[randi() % sounds.size()]
	pitch_scale = rand_range(0.9, 1.3)
	while abs(pitch_scale - last_pitch) < 0.1:
		pitch_scale = rand_range(0.9, 1.3)
	.play(from_position)

